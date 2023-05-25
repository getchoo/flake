{
  inputs,
  myLib,
  self,
  withSystem,
  ...
}: {
  flake = {
    nixosConfigurations = let
      inherit (myLib.configs) mkNixOS;

      profiles = import ./profiles.nix {inherit self inputs;};
    in {
      glados = mkNixOS {
        name = "glados";
        modules = with inputs; [
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          nixos-hardware.nixosModules.common-pc-ssd
          lanzaboote.nixosModules.lanzaboote
        ];
        profile = profiles.personal;
      };

      glados-wsl = mkNixOS {
        name = "glados-wsl";
        modules = [inputs.nixos-wsl.nixosModules.wsl];
        profile = profiles.personal;
      };

      atlas = mkNixOS {
        name = "atlas";
        system = "aarch64-linux";
        profile = profiles.server;
      };

      p-body = mkNixOS {
        name = "p-body";
        modules = [inputs.guzzle_api.nixosModules.guzzle_api];
        system = "x86_64-linux";
        profile = profiles.server;
      };
    };

    nixosModules.getchoo = import ../modules/nixos;

    packages.x86_64-linux.turret = withSystem "x86_64-linux" ({pkgs, ...}:
      pkgs.callPackage ./turret {
        inherit (inputs) openwrt-imagebuilder;
      });
  };

  perSystem = {system, ...}: {
    apps = (inputs.nixinate.nixinate.${system} self).nixinate;
  };
}
