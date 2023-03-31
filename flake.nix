{
  description = "getchoo's flake for system configurations";

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
      inputs.utils.follows = "flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
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
    flake-utils,
    openwrt-imagebuilder,
    pre-commit-hooks,
    ...
  }: let
    inherit
      (import ./util {
        inherit (nixpkgs) lib;
        inherit inputs;
      })
      mapHosts
      mapHMUsers
      ;

    users = import ./users {inherit inputs;};
    hosts = import ./hosts {inherit inputs;};
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
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

      homeConfigurations = mapHMUsers (users.users {inherit system;});
    })
    // {
      nixosConfigurations = mapHosts hosts;

      packages.x86_64-linux.turret = nixpkgs.legacyPackages.x86_64-linux.callPackage ./hosts/turret {inherit openwrt-imagebuilder;};
    };
}
