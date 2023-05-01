{
  description = "getchoo's flake for system configurations";

  nixConfig = {
    extra-substituters = [
      "https://getchoo.cachix.org" # personal cache
      "https://nix-community.cachix.org" # nix-community
      "https://hercules-ci.cachix.org" # hercules-ci
      "https://wurzelpfropf.cachix.org" # rage-nix
    ];
    extra-trusted-public-keys = [
      "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
      "wurzelpfropf.cachix.org-1:ilZwK5a6wJqVr7Fyrzp4blIEkGK+LJT0QrpWr1qBNq0="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    # this is just to avoid having multiple versions in flake.lock
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    # ditto
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgsUnstable";
    };
    getchoo = {
      url = "github:getchoo/overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    guzzle_api = {
      url = "github:getchoo/guzzle_api";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };
    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hercules-ci-agent = {
      url = "github:hercules-ci/hercules-ci-agent";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
    };
    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
      inputs.flake-parts.follows = "flake-parts";
      inputs.hercules-ci-agent.follows = "hercules-ci-agent";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
    };
    nixinate = {
      url = "github:MatthewCroughan/nixinate";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    openwrt-imagebuilder = {
      url = "github:astro/nix-openwrt-imagebuilder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    getchoo,
    haumea,
    hercules-ci-effects,
    nixpkgs,
    nixinate,
    openwrt-imagebuilder,
    pre-commit-hooks,
    ragenix,
    ...
  }: let
    inherit (getchooLib.configs) mapHMUsers mapHosts;

    getchooLib = with inputs; let
      args = {
        users = with haumea.lib;
          load {
            src = ./users;
            loader = loaders.path;
          };
      };
    in
      getchoo.lib (inputs // args);
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        hercules-ci-effects.flakeModule
      ];

      flake = {
        nixosConfigurations = mapHosts ./hosts;

        nixosModules.getchoo = import ./modules;
      };

      hercules-ci = {
        flake-update = {
          enable = true;
          when = {
            hour = [0];
            minute = 0;
          };
        };
      };

      herculesCI = let
        inherit (import (hercules-ci-effects + "/vendor/hercules-ci-agent/default-herculesCI-for-flake.nix")) flakeToOutputs;
      in rec {
        ciSystems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        onPush = {
          default = {
            outputs = with builtins;
            with nixpkgs.lib; let
              # use defaults, but only evaluate hosts
              defaults =
                removeAttrs
                (flakeToOutputs self {
                  ciSystems = genAttrs ciSystems (_: {});
                })
                ["nixosConfigurations" "packages"];

              evaluate = mapAttrs (_: v:
                seq
                v.config.system.build.toplevel
                v._module.args.pkgs.emptyFile)
              self.nixosConfigurations;
            in
              mkForce (defaults // evaluate);
          };
        };
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        apps = (nixinate.nixinate.${system} self).nixinate;
        checks = {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              actionlint.enable = true;
              alejandra.enable = true;
              deadnix.enable = true;
              statix.enable = true;
              stylua.enable = true;
            };
          };
        };

        devShells = let
          inherit (pkgs) mkShell;
        in {
          default = mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            packages = with inputs;
            with pkgs; [
              actionlint
              ragenix.packages.${system}.ragenix
              alejandra
              deadnix
              fzf
              git-crypt
              just
              statix
              stylua
            ];
          };
        };

        formatter = pkgs.alejandra;

        legacyPackages.homeConfigurations = mapHMUsers system ./users;

        packages = with inputs;
        with pkgs; {
          turret = callPackage ./hosts/_turret {inherit openwrt-imagebuilder;};
        };
      };
    };
}
