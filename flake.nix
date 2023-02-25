{
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL?ref=main";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs @ {
    home-manager,
    lanzaboote,
    nixos-hardware,
    nixos-wsl,
    nixpkgs,
    nixpkgsUnstable,
    nur,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
    util = import ./util {inherit inputs home-manager;};
    inherit (util) host user;
  in {
    homeConfigurations = {
      seth = user.mkHMUser {
        username = "seth";
        stateVersion = "23.05";
        channel = nixpkgsUnstable;
        modules = [];
        extraSpecialArgs = {
          standalone = true;
        };
      };
    };

    nixosConfigurations =
      (host.mkHost {
        name = "glados";
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          nixos-hardware.nixosModules.common-pc-ssd
          lanzaboote.nixosModules.lanzaboote
          nur.nixosModules.nur

          ./users/seth
          {
            nixpkgs.overlays = [nur.overlay];
          }
        ];
        specialArgs = {
          desktop = "gnome";
          standalone = false;
          wsl = false;
        };
        version = "23.05";
        pkgs = nixpkgsUnstable;
      })
      // (host.mkHost {
        name = "glados-wsl";
        modules = [
          nixos-wsl.nixosModules.wsl

          {
            wsl = {
              enable = true;
              defaultUser = "seth";
              nativeSystemd = true;
              wslConf.network.hostname = "glados-wsl";
              startMenuLaunchers = false;
              interop.includePath = false;
            };
          }

          ./users/seth
        ];
        specialArgs = {
          desktop = "";
          standalone = false;
          wsl = true;
        };
        version = "23.05";
        pkgs = nixpkgsUnstable;
      });

    formatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);
  };
}
