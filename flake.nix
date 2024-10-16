{
  description = "getchoo's flake for system configurations";

  nixConfig = {
    extra-substituters = [ "https://getchoo.cachix.org" ];
    extra-trusted-public-keys = [ "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE=" ];
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      inherit (self.lib.builders) darwinSystem homeManagerConfiguration nixosSystem;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = lib.genAttrs systems;
      nixpkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
      treefmtFor = forAllSystems (
        system: inputs.treefmt-nix.lib.evalModule nixpkgsFor.${system} ./treefmt.nix
      );
    in
    {
      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};

          opentofu = pkgs.opentofu.withPlugins (plugins: [
            plugins.cloudflare
            plugins.tailscale
          ]);

          terranix = inputs.terranix.lib.terranixConfiguration {
            inherit system;
            modules = [ ./terranix ];
          };
        in
        {
          tf = {
            type = "app";
            program = lib.getExe (
              pkgs.writeShellScriptBin "tf" ''
                ln -sf ${terranix} config.tf.json
                exec ${lib.getExe opentofu} "$@"
              ''
            );
          };
        }
      );

      checks = forAllSystems (system: {
        treefmt = treefmtFor.${system}.config.build.check self;
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          nixos-rebuild = pkgs.nixos-rebuild.override { nix = pkgs.lix; };
          inherit (inputs.nix-darwin.packages.${system}) darwin-rebuild;
        in
        {
          default = pkgs.mkShellNoCC {
            packages =
              [
                # For CI
                pkgs.actionlint

                # Nix tools
                pkgs.nixfmt-rfc-style
                pkgs.nil
                pkgs.statix

                self.formatter.${system}
                pkgs.just
              ]
              ++ lib.optional pkgs.stdenv.isDarwin darwin-rebuild # See next comment
              ++ lib.optionals pkgs.stdenv.isLinux [
                # we want to make sure we have the same
                # nix behavior across machines
                pkgs.lix

                # ditto
                nixos-rebuild

                inputs.agenix.packages.${system}.agenix
              ];
          };
        }

      );

      lib = import ./lib { inherit lib inputs self; };

      formatter = forAllSystems (system: treefmtFor.${system}.config.build.wrapper);

      darwinModules = import ./modules/darwin;
      homeModules = import ./modules/home;
      nixosModules = import ./modules/nixos;

      darwinConfigurations = lib.mapAttrs (_: darwinSystem) {
        caroline = {
          modules = [ ./systems/caroline ];
        };
      };

      homeConfigurations = lib.mapAttrs (_: homeManagerConfiguration) {
        seth = {
          modules = [ ./users/seth/home.nix ];
          pkgs = nixpkgsFor.x86_64-linux;
        };
      };

      nixosConfigurations = lib.mapAttrs (_: nixosSystem) {
        glados = {
          modules = [ ./systems/glados ];
        };

        glados-wsl = {
          modules = [ ./systems/glados-wsl ];
        };

        atlas = {
          nixpkgs = inputs.nixpkgs-stable;
          modules = [ ./systems/atlas ];
        };
      };

      legacyPackages.x86_64-linux =
        let
          pkgs = nixpkgsFor.x86_64-linux;

          openwrtTools = lib.makeScope pkgs.newScope (final: {
            profileFromRelease =
              release: (inputs.openwrt-imagebuilder.lib.profiles { inherit pkgs release; }).identifyProfile;

            buildOpenWrtImage =
              { profile, ... }@args:
              inputs.openwrt-imagebuilder.lib.build (
                final.profileFromRelease args.release profile
                // builtins.removeAttrs args [
                  "profile"
                  "release"
                ]
              );
          });
        in
        {
          turret = openwrtTools.callPackage ./openwrt/turret.nix { };
        };

      hydraJobs =
        let
          # architecture of "main" CI machine
          ciSystem = "x86_64-linux";

          derivFromCfg = deriv: deriv.config.system.build.toplevel or deriv.activationPackage;
          mapCfgsToDerivs = lib.mapAttrs (lib.const derivFromCfg);

          pkgs = nixpkgsFor.${ciSystem};
        in
        {
          # i don't care to run these for each system, as they should be the same
          # and don't need to be cached
          checks = self.checks.${ciSystem};
          devShells = self.devShells.${ciSystem};

          darwinConfigurations = mapCfgsToDerivs self.darwinConfigurations;
          homeConfigurations = mapCfgsToDerivs self.homeConfigurations;
          nixosConfigurations = mapCfgsToDerivs self.nixosConfigurations // {
            # please add aarch64 runners github...please...
            atlas = lib.deepSeq (derivFromCfg self.nixosConfigurations.atlas).drvPath pkgs.emptyFile;
          };
        };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
        home-manager.follows = "";
        systems.follows = "nixos-wsl/flake-utils/systems";
      };
    };

    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        pre-commit.follows = "";
        flake-utils.follows = "nixos-wsl/flake-utils";
      };
    };

    catppuccin.url = "github:catppuccin/nix";

    firefox-addons = {
      url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "nixos-wsl/flake-utils";
      };
    };

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
      };
    };

    nixpkgs-tracker-bot = {
      url = "github:getchoo/nixpkgs-tracker-bot";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
    };

    openwrt-imagebuilder = {
      url = "github:astro/nix-openwrt-imagebuilder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    teawiebot = {
      url = "github:getchoo/teawiebot";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
    };

    terranix = {
      url = "github:terranix/terranix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "nixos-wsl/flake-utils";
        terranix-examples.follows = "";
        bats-support.follows = "";
        bats-assert.follows = "";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
