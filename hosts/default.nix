{
  inputs,
  self,
  withSystem,
  ...
}: {
  flake = let
    inherit (self.lib.configs) mapSystems;
    profiles = import ./profiles.nix {inherit self inputs;};
  in {
    darwinConfigurations = mapSystems {
      caroline = {
        system = "x86_64-darwin";
        profile = profiles.personal-darwin;
      };
    };

    nixosConfigurations = mapSystems {
      glados = {
        modules = with inputs; [
          lanzaboote.nixosModules.lanzaboote
        ];
        profile = profiles.personal;
      };

      glados-wsl = {
        modules = [inputs.nixos-wsl.nixosModules.wsl];
        profile = profiles.personal;
      };

      atlas = {
        modules = [inputs.guzzle_api.nixosModules.default];
        system = "aarch64-linux";
        profile = profiles.server;
      };
    };

    openwrtConfigurations.turret = withSystem "x86_64-linux" ({pkgs, ...}:
      pkgs.callPackage ./turret {
        inherit (inputs) openwrt-imagebuilder;
      });
  };

  perSystem = {system, ...}: {
    apps = (inputs.nixinate.nixinate.${system} self).nixinate;
  };
}
