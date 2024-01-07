{
  lib,
  withSystem,
  inputs,
  self,
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
        specialArgs = {
          inherit inputs self;
          inputs' = withSystem (args.system or "x86_64-linux") ({inputs', ...}: inputs');
          secretsDir = ../secrets/${name};
        };
      }
    );

  mapSystems = builder: lib.mapAttrs (toSystem builder);

  mapDarwin = mapSystems inputs.darwin.lib.darwinSystem;
  mapNixOS = mapSystems inputs.nixpkgs.lib.nixosSystem;
  common = import ./common.nix {inherit inputs self;};
in {
  imports = [./deploy.nix];

  flake = {
    darwinConfigurations = mapDarwin {
      caroline = {
        system = "x86_64-darwin";
        modules = common.darwin;
      };
    };

    nixosConfigurations = mapNixOS {
      glados = {
        system = "x86_64-linux";
        modules = common.personal;
      };

      glados-wsl = {
        system = "x86_64-linux";
        modules = common.personal;
      };

      atlas = {
        builder = inputs.nixpkgs-stable.lib.nixosSystem;
        system = "aarch64-linux";
        modules = common.server;
      };
    };

    legacyPackages.x86_64-linux.turret = withSystem "x86_64-linux" ({pkgs, ...}:
      pkgs.callPackage ./turret {
        inherit (inputs) openwrt-imagebuilder;
      });
  };
}
