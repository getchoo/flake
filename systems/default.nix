{
  lib,
  inputs,
  self,
  withSystem,
  ...
}: let
  /*
  basic nixosSystem/darwinSystem wrapper; can override
  the exact builder by supplying an argument
  */
  toSystem = builder: name: args:
    (args.builder or builder) (
      (builtins.removeAttrs args ["builder"])
      // {
        modules = args.modules ++ [./${name}];
        specialArgs = {inherit inputs self;};
      }
    );

  mapSystems = builder: lib.mapAttrs (toSystem builder);

  mapDarwin = mapSystems inputs.darwin.lib.darwinSystem;
  mapNixOS = mapSystems inputs.nixpkgs.lib.nixosSystem;
  inherit (import ./common.nix {inherit inputs self;}) darwin nixos server;
in {
  imports = [
    ./deploy.nix
  ];

  flake = {
    darwinConfigurations = mapDarwin {
      caroline = {
        system = "x86_64-darwin";
        modules = darwin;
      };
    };

    nixosConfigurations = mapNixOS {
      glados = {
        system = "x86_64-linux";
        modules = with inputs;
          [
            lanzaboote.nixosModules.lanzaboote
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
            {
              hardware.nvidia.modesetting.enable = true;
            }
          ]
          ++ nixos;
      };

      glados-wsl = {
        system = "x86_64-linux";
        modules =
          [
            inputs.nixos-wsl.nixosModules.wsl
          ]
          ++ nixos;
      };

      atlas = {
        builder = inputs.nixpkgs-stable.lib.nixosSystem;
        system = "aarch64-linux";
        modules =
          [
            inputs.teawiebot.nixosModules.default
          ]
          ++ server;
      };
    };

    openwrtConfigurations.turret = withSystem "x86_64-linux" ({pkgs, ...}:
      pkgs.callPackage ./turret {
        inherit (inputs) openwrt-imagebuilder;
      });
  };
}
