{
  description = "getchoo's flake for system configurations";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  inputs = {
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
    getchoo = {
      url = "github:getchoo/overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: remove when this commit is used in lanzaboote:
    # https://github.com/oxalica/rust-overlay/commit/c949d341f2b507857d589c48d1bd719896a2a224
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
      # TODO: ditto
      inputs.rust-overlay.follows = "rust-overlay";
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
    nixpkgs,
    agenix,
    getchoo,
    flake-utils,
    openwrt-imagebuilder,
    pre-commit-hooks,
    ...
  }: let
    getchooLib = getchoo.lib (inputs // {inherit self;});

    inherit (getchooLib.configs) mapHMUsers mapHosts;
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
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

      devShells = with pkgs; {
        default = mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          packages = [
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

      homeConfigurations = mapHMUsers system ./users;
    })
    // {
      nixosConfigurations = mapHosts ./hosts;

      nixosModules.getchoo = import ./modules;

      packages.x86_64-linux = let
        pkgs = import nixpkgs {system = "x86_64-linux";};
      in {
        turret = pkgs.callPackage ./hosts/turret {inherit openwrt-imagebuilder;};
      };
    };
}
