{
  description = "getchoo's flake for system configurations";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hercules-ci.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    # this is just to avoid having multiple versions in flake.lock
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
    };
    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs.nixpkgs.follows = "nixpkgs";
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
  };

  outputs = inputs @ {
    self,
    agenix,
    haumea,
    getchoo,
    nixpkgs,
    nixinate,
    openwrt-imagebuilder,
    pre-commit-hooks,
    flake-parts,
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
        inputs.hercules-ci-effects.flakeModule
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
        inherit (import (inputs.hercules-ci-effects + "/vendor/hercules-ci-agent/default-herculesCI-for-flake.nix")) flakeToOutputs;
      in rec {
        ciSystems = ["x86_64-linux"];
        onPush = {
          default = {
            outputs = with nixpkgs.lib;
            # use defaults, but don't build hosts
              mkForce (builtins.removeAttrs
                (flakeToOutputs self {ciSystems = genAttrs ciSystems (_: {});})
                ["nixosConfigurations" "packages"]);
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
              agenix.packages.${system}.agenix
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
