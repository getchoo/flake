{
  inputs = {
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    getchoo = {
      url = "github:getchoo/overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgsUnstable,
    getchoo,
    home-manager,
    lanzaboote,
    nixos-hardware,
    nixos-wsl,
    nur,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});

    util = import ./util {inherit inputs home-manager;};
    inherit (util) host user;

    seth = {
      specialArgs ? {},
      pkgs ? nixpkgsUnstable,
    }:
      forAllSystems (system: import ./users/seth {inherit pkgs specialArgs system user;});
  in {
    homeConfigurations = forAllSystems (system: {
      inherit ((seth {}).${system}.hm) seth;
    });

    nixosConfigurations =
      (host.mkHost rec {
        name = "glados";
        specialArgs = {
          desktop = "gnome";
          standalone = false;
          wsl = false;
        };
        version = "23.05";
        pkgs = nixpkgsUnstable;
        modules =
          [
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
            lanzaboote.nixosModules.lanzaboote
            nur.nixosModules.nur

            {
              nixpkgs.overlays = [nur.overlay getchoo.overlays.default];
              nix.registry.getchoo.flake = getchoo;
            }
          ]
          ++ (seth {inherit specialArgs pkgs;}).x86_64-linux.system;
      })
      // (host.mkHost rec {
        name = "glados-wsl";
        specialArgs = {
          desktop = "";
          standalone = false;
          wsl = true;
        };
        version = "23.05";
        pkgs = nixpkgsUnstable;
        modules =
          [
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

              nixpkgs.overlays = [getchoo.overlays.default];
              nix.registry.getchoo.flake = getchoo;
            }
          ]
          ++ (seth {inherit specialArgs pkgs;}).x86_64-linux.system;
      });

    formatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);
  };
}
