{
  description = "getchoo's flake for system configurations";

  nixConfig = {
    extra-substituters = ["https://cache.garnix.io"];
    extra-trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
  };

  outputs = inputs: let
    flakeModules = import ./modules/flake;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({self, ...}: {
      imports = [
        ./lib
        ./modules
        ./overlay
        ./systems
        ./users

        ./ext # nix expressions for *external*, not so nix-y things

        inputs.pre-commit.flakeModule
        inputs.treefmt-nix.flakeModule

        # dogfooding
        flakeModules.configurations
        flakeModules.openwrt
        flakeModules.terranix
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        config,
        lib,
        pkgs,
        system,
        inputs',
        self',
        ...
      }: {
        treefmt = {
          projectRootFile = "flake.nix";

          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            prettier.enable = true;
          };

          settings.global = {
            excludes = [
              "./flake.lock"
            ];
          };
        };

        pre-commit.settings.hooks = {
          actionlint.enable = true;

          treefmt = {
            enable = true;
            package = config.treefmt.build.wrapper;
          };

          nil.enable = true;
          statix.enable = true;
        };

        devShells.default = pkgs.mkShellNoCC {
          shellHook = config.pre-commit.installationScript;
          packages = with pkgs;
            [
              nix

              # format + lint
              actionlint
              self'.formatter
              deadnix
              nil
              statix

              # utils
              deploy-rs
              fzf
              just
              config.terranix.package
            ]
            ++ lib.optional stdenv.isDarwin [inputs'.darwin.packages.darwin-rebuild]
            ++ lib.optionals stdenv.isLinux [nixos-rebuild inputs'.agenix.packages.agenix];
        };

        packages.ciGate = let
          ci = self.lib.ci [system];

          configurations = map (type: ci.mapCfgsToDerivs (ci.getCompatibleCfgs self.${type})) [
            "nixosConfigurations"
            "darwinConfigurations"
            "homeConfigurations"
          ];

          required = lib.concatMap lib.attrValues (
            [
              self'.checks
              self'.devShells
            ]
            ++ configurations
          );
        in
          pkgs.writeText "ci-gate" (
            lib.concatMapStringsSep "\n" toString required
          );
      };
    });

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    darwin = {
      url = "github:LnL7/nix-darwin/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
        home-manager.follows = "";
        systems.follows = "pre-commit/flake-utils/systems";
      };
    };

    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        pre-commit.follows = "";
        flake-utils.follows = "pre-commit/flake-utils";
      };
    };

    catppuccin.url = "github:Stonks3141/ctp-nix";

    deploy = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        utils.follows = "pre-commit/flake-utils";
      };
    };

    firefox-addons = {
      url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "pre-commit/flake-utils";
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
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "pre-commit/flake-utils";
        pre-commit-hooks-nix.follows = "pre-commit";
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
        flake-utils.follows = "pre-commit/flake-utils";
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

    pre-commit = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };

    teawiebot = {
      url = "github:getchoo/teawiebot";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        pre-commit-hooks-nix.follows = "pre-commit";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    terranix = {
      url = "github:terranix/terranix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "pre-commit/flake-utils";
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
