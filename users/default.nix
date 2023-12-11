{
  lib,
  withSystem,
  inputs,
  self,
  ...
}: let
  /*
  basic homeManagerConfiguration wrapper. defaults to x86_64-linux
  and gives basic, nice defaults
  */
  mkUser = name: args:
    inputs.hm.lib.homeManagerConfiguration (args
      // {
        modules =
          [
            ./${name}/home.nix

            {
              _module.args.osConfig = {};
              programs.home-manager.enable = true;
            }
          ]
          ++ (args.modules or []);

        extraSpecialArgs = {
          inherit inputs self;
          inputs' = withSystem (args.system or "x86_64-linux") ({inputs', ...}: inputs');
        };

        pkgs = args.pkgs or inputs.nixpkgs.legacyPackages."x86_64-linux";
      });

  mapUsers = lib.mapAttrs mkUser;
in {
  flake.homeConfigurations = mapUsers {
    seth = {};
  };
}
