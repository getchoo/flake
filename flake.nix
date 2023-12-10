{
  description = "getchoo's flake for system configurations";

  nixConfig = {
    extra-substituters = ["https://cache.mydadleft.me/getchoo"];
    extra-trusted-public-keys = ["getchoo:rH35+W+4SV7UV9RTr69LwkH7b24Djui2ZQIQvPxzJCg="];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
    darwin = {
      url = "github:LnL7/nix-darwin/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "darwin";
        home-manager.follows = "hm";
      };
    };

    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "pre-commit/flake-compat";
        pre-commit.follows = "pre-commit";
        flake-utils.follows = "pre-commit/flake-utils";
      };
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
        crane.follows = "lanzaboote/crane";
        flake-utils.follows = "pre-commit/flake-utils";
        flake-compat.follows = "pre-commit/flake-compat";
      };
    };

    catppuccin = {
      url = "github:Stonks3141/ctp-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "hm";
      };
    };

    firefox-addons = {
      url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "pre-commit/flake-utils";
      };
    };

    getchoo = {
      url = "github:getchoo/nix-exprs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    getchvim = {
      url = "github:getchoo/getchvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        parts.follows = "parts";
        pre-commit.follows = "pre-commit";
      };
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "pre-commit/flake-compat";
        flake-parts.follows = "parts";
        flake-utils.follows = "pre-commit/flake-utils";
        pre-commit-hooks-nix.follows = "pre-commit";
      };
    };

    nix2workflow = {
      url = "github:getchoo/nix2workflow";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixinate = {
      url = "github:MatthewCroughan/nixinate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "pre-commit/flake-compat";
        flake-utils.follows = "pre-commit/flake-utils";
      };
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
      };
    };

    teawiebot = {
      url = "github:getchoo/teawiebot";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        parts.follows = "parts";
        pre-commit.follows = "pre-commit";
      };
    };
  };

  outputs = {parts, ...} @ inputs:
    parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.pre-commit.flakeModule
        inputs.nix2workflow.flakeModule

        ./modules
        ./overlay
        ./systems
        ./users
        ./dev.nix
        ./workflow.nix
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
}
