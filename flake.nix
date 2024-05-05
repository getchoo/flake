{
  description = "getchoo's flake for system configurations";

  nixConfig = {
    extra-substituters = ["https://cache.garnix.io"];
    extra-trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    flake-checks,
    terranix,
    ...
  } @ inputs: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn nixpkgs.legacyPackages.${system});
    inputsFor = forAllSystems ({system, ...}: self.lib.utils.inputsFor system);
  in {
    checks = forAllSystems ({
      lib,
      pkgs,
      ...
    }: {
      inherit
        (flake-checks.lib.mkChecks {
          root = ./.;
          inherit pkgs;
        })
        actionlint
        alejandra
        deadnix
        editorconfig
        statix
        ;
    });

    devShells = forAllSystems ({
      lib,
      pkgs,
      system,
      ...
    }: let
      inputs' = inputsFor.${system};
      self' = inputs'.self;
    in {
      default = pkgs.mkShellNoCC {
        packages =
          [
            pkgs.nix

            # format + lint
            pkgs.actionlint
            self'.formatter
            pkgs.deadnix
            pkgs.nil
            pkgs.statix

            # utils
            pkgs.deploy-rs
            pkgs.fzf
            pkgs.just
            self'.packages.opentofu
          ]
          ++ lib.optional pkgs.stdenv.isDarwin [inputs'.darwin.packages.darwin-rebuild]
          ++ lib.optionals pkgs.stdenv.isLinux [pkgs.nixos-rebuild inputs'.agenix.packages.agenix];
      };
    });

    darwinConfigurations = let
      builder = inputs.darwin.lib.darwinSystem;
    in
      self.lib.configs.mapDarwin {
        caroline = {
          inherit builder;
          system = "x86_64-darwin";
        };
      };

    darwinModules = import ./modules/darwin;

    deploy = {
      remoteBuild = true;
      fastConnection = false;
      nodes = self.lib.deploy.mapNodes [
        "atlas"
      ];
    };

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    homeConfigurations = let
      unstableFor = nixpkgs.legacyPackages;
    in
      self.lib.configs.mapUsers {
        seth = {
          pkgs = unstableFor.x86_64-linux;
        };
      };

    legacyPackages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      setDefaults = opts:
        pkgs.runCommand "image-files" {} ''
          mkdir -p $out/etc/uci-defaults

          cat > $out/etc/uci-defaults/99-custom << EOF
          uci -q batch << EOI
          ${opts}
          commit
          EOI
          EOF
        '';
    in {
      openWrtImages = self.lib.openwrt.mapImagesWith pkgs {
        turret = {
          release = "23.05.0";
          profile = "netgear_wac104";

          files = setDefaults ''
            set system.@system[0].hostname="turret"
            del_list network.@device[0].ports="lan4"
            set network.wan="interface"
            set network.wan.device="lan4"
            set network.wan.proto="dhcp"
            set wireless.default_radio0.ssid="Box-2.4G"
            set wireless.default_radio0.encryption="psk2"
            set wireless.default_radio0.key="CorrectHorseBatteryStaple"
            set wireless.default_radio1.ssid="Box-5G"
            set wireless.default_radio1.encryption="psk2"
            set wireless.default_radio1.key="CorrectHorseBatteryStaple"
            add_list dhcp.@dnsmasq[0].server="1.1.1.1"
            add_list dhcp.@dnsmasq[0].server="1.0.0.1"
          '';
        };
      };
    };

    lib = (nixpkgs.lib.extend (import ./lib inputs)).my;

    nixosConfigurations = let
      unstable = nixpkgs.lib.nixosSystem;
      stable = nixpkgs-stable.lib.nixosSystem;
    in
      self.lib.configs.mapNixOS {
        glados = {
          builder = unstable;
          system = "x86_64-linux";
        };

        glados-wsl = {
          builder = unstable;
          system = "x86_64-linux";
        };

        atlas = {
          builder = stable;
          system = "aarch64-linux";
        };
      };

    nixosModules = import ./modules/nixos;

    overlays.default = import ./overlay;

    packages = forAllSystems ({
      lib,
      pkgs,
      system,
      ...
    }: {
      ciGate = let
        inherit (self.lib.ci) toTopLevel;
        self' = inputsFor.${system}.self;
        isCompatible = self.lib.ci.isCompatibleWith system;

        configurations =
          map
          (type:
            lib.mapAttrs (lib.const toTopLevel)
            (lib.filterAttrs (lib.const isCompatible) self.${type}))
          [
            "nixosConfigurations"
            "darwinConfigurations"
            "homeConfigurations"
          ];

        required = lib.concatMap lib.attrValues (
          lib.flatten [self'.checks self'.devShells configurations]
        );
      in
        pkgs.writeText "ci-gate" (
          lib.concatMapStringsSep "\n" toString required
        );

      opentofu = pkgs.opentofu.withPlugins (plugins: [
        plugins.cloudflare
        plugins.tailscale
      ]);

      terranix = terranix.lib.terranixConfiguration {
        inherit system;
        modules = [./terranix];
      };
    });
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    darwin = {
      url = "github:LnL7/nix-darwin/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
        home-manager.follows = "";
        systems.follows = "lanzaboote/flake-utils/systems";
      };
    };

    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        pre-commit.follows = "";
        flake-utils.follows = "lanzaboote/flake-utils";
      };
    };

    catppuccin.url = "github:catppuccin/nix";

    deploy = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        utils.follows = "lanzaboote/flake-utils";
      };
    };

    firefox-addons = {
      url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "lanzaboote/flake-utils";
      };
    };

    flake-checks.url = "github:getchoo/flake-checks";

    getchvim = {
      url = "github:getchoo/getchvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    krunner-nix = {
      url = "github:pluiedev/krunner-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        pre-commit-hooks-nix.follows = "";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        flake-utils.follows = "lanzaboote/flake-utils";
      };
    };

    nu-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };

    openwrt-imagebuilder = {
      url = "github:astro/nix-openwrt-imagebuilder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    teawiebot = {
      url = "github:getchoo/teawiebot";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    terranix = {
      url = "github:terranix/terranix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "lanzaboote/flake-utils";
        terranix-examples.follows = "";
        bats-support.follows = "";
        bats-assert.follows = "";
      };
    };
  };
}
