{
  description = "Getchoo's Flake for system configurations";

  nixConfig = {
    extra-substituters = [ "https://getchoo.cachix.org" ];
    extra-trusted-public-keys = [ "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE=" ];
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      inherit (self.lib.builders)
        darwinSystem
        homeManagerConfiguration
        nixosSystem
        mkModule
        ;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = lib.genAttrs systems;
      nixpkgsFor = nixpkgs.legacyPackages;
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

          flake-inputs = mkCheck {
            name = "check-flake-inputs";
            script = ''
              if grep '_2' ${self}/flake.lock &>/dev/null; then
                echo "FOUND DUPLICATE FLAKE INPUTS!!!!"
                exit 1
              fi
            '';
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
            script = "nixfmt --check ${self}";
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

      lib = import ./lib { inherit lib inputs self; };

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixfmt-rfc-style);

      darwinModules = {
        default = mkModule {
          name = "default";
          type = "darwin";
          imports = [ ./modules/darwin ];
        };
      };

      nixosModules = {
        default = mkModule {
          name = "default";
          type = "nixos";
          imports = [ ./modules/nixos ];
        };
      };

      darwinConfigurations = lib.mapAttrs (lib.const darwinSystem) {
        caroline = {
          modules = [ ./systems/caroline ];
        };
      };

      homeConfigurations = lib.mapAttrs (lib.const homeManagerConfiguration) {
        seth = {
          modules = [ ./users/seth/home.nix ];
          pkgs = nixpkgsFor.x86_64-linux;
        };
      };

      nixosConfigurations = lib.mapAttrs (lib.const nixosSystem) {
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
        flake-parts.follows = "lanzaboote/flake-parts";
        systems.follows = "nixos-wsl/flake-utils/systems";
        terranix-examples.follows = "";
        bats-support.follows = "";
        bats-assert.follows = "";
      };
    };
  };
}
