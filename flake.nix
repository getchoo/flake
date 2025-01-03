{
  description = "Getchoo's Flake for system configurations";

  nixConfig = {
    extra-substituters = [ "https://getchoo.cachix.org" ];
    extra-trusted-public-keys = [ "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE=" ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nix-darwin,
      home-manager,
      ...
    }@inputs:

    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = lib.genAttrs systems;
      nixpkgsFor = nixpkgs.legacyPackages;

      mkModule = type: name: file: {
        _file = "${self.outPath}#${type}.${name}";
        imports = [ file ];
      };
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

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};

          mkCheck =
            {
              name,
              deps ? [ ],
              script,
            }:
            pkgs.runCommand name { nativeBuildInputs = deps; } ''
              ${script}
              touch $out
            '';
        in
        {
          actionlint = mkCheck {
            name = "check-actionlint";
            deps = [ pkgs.actionlint ];
            script = "actionlint ${self}/.github/workflows/**";
          };

          deadnix = mkCheck {
            name = "check-deadnix";
            deps = [ pkgs.deadnix ];
            script = "deadnix --fail ${self}";
          };

          just = mkCheck {
            name = "check-just";
            deps = [ pkgs.just ];
            script = ''
              cd ${self}
              just --check --fmt --unstable
              just --summary
            '';
          };

          nixfmt = mkCheck {
            name = "check-nixfmt";
            deps = [ pkgs.nixfmt-rfc-style ];
            script = "nixfmt --check ${self}/**/*.nix";
          };

          statix = mkCheck {
            name = "check-statix";
            deps = [ pkgs.statix ];
            script = "statix check ${self}";
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            packages =
              [
                # We want to make sure we have the same
                # Nix behavior across machines
                pkgs.nix

                # For CI
                pkgs.actionlint

                # Nix tools
                pkgs.nil
                pkgs.statix
                self.formatter.${system}

                pkgs.just
              ]
              ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
                # See above comment about Nix
                inputs.nix-darwin.packages.${system}.darwin-rebuild
              ]
              ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [

                # Ditto
                pkgs.nixos-rebuild

                inputs.agenix.packages.${system}.agenix
              ];
          };
        }
      );

      lib = import ./lib { inherit lib; };

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixfmt-rfc-style);

      darwinModules = lib.mapAttrs (mkModule "darwin") {
        default = ./modules/darwin;
      };

      nixosModules = lib.mapAttrs (mkModule "darwin") {
        default = ./modules/nixos;
      };

      darwinConfigurations = lib.mapAttrs (lib.const nix-darwin.lib.darwinSystem) {
        caroline = {
          modules = [ ./systems/caroline ];
          specialArgs = {
            inherit inputs;
          };
        };
      };

      homeConfigurations = lib.mapAttrs (lib.const home-manager.lib.homeManagerConfiguration) {
        seth = {
          modules = [ ./users/seth/home.nix ];
          pkgs = nixpkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };

      nixosConfigurations =
        lib.mapAttrs (lib.const nixpkgs.lib.nixosSystem) {
          glados = {
            modules = [ ./systems/glados ];
            specialArgs = {
              inherit inputs;
            };
          };

          glados-wsl = {
            modules = [ ./systems/glados-wsl ];
            specialArgs = {
              inherit inputs;
            };
          };
        }
        // {
          atlas = nixpkgs-stable.lib.nixosSystem {
            modules = [ ./systems/atlas ];
            specialArgs = {
              inherit inputs;
            };
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
          # Architecture of "main" CI machine
          ciSystem = "x86_64-linux";

          derivFromCfg = deriv: deriv.config.system.build.toplevel or deriv.activationPackage;
          mapCfgsToDerivs = lib.mapAttrs (lib.const derivFromCfg);

          pkgs = nixpkgsFor.${ciSystem};
        in
        {
          # I don't care to run these for each system, as they should be the same
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

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

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "";
        home-manager.follows = "";
        home-manager-stable.follows = "";
        nuscht-search.follows = "";
        catppuccin-v1_1.follows = "";
        catppuccin-v1_2.follows = "";
      };
    };

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

    nix-exprs = {
      url = "github:getchoo/nix-exprs";
      inputs.nixpkgs.follows = "nixpkgs";
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
        nix-filter.follows = "getchvim/nix-filter";
        treefmt-nix.follows = "";
      };
    };

    openwrt-imagebuilder = {
      url = "github:astro/nix-openwrt-imagebuilder";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "lanzaboote/flake-parts";
        systems.follows = "nixos-wsl/flake-utils/systems";
      };
    };

    teawiebot = {
      url = "github:getchoo/teawiebot";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    terranix = {
      url = "github:terranix/terranix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "lanzaboote/flake-parts";
        systems.follows = "nixos-wsl/flake-utils/systems";
        terranix-examples.follows = "";
        bats-support.follows = "";
        bats-assert.follows = "";
      };
    };
  };
}
