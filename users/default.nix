{
  inputs,
  self,
  ...
}: {
  perSystem = {
    lib,
    pkgs,
    inputs',
    ...
  }: let
    # basic homeManagerConfiguration wrapper with nice defaults
    mkUser = name: args:
      inputs.hm.lib.homeManagerConfiguration (lib.recursiveUpdate args {
        pkgs = args.pkgs or pkgs;

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
          inherit inputs inputs' self;
        };
      });

    mapUsers = lib.mapAttrs mkUser;
  in {
    legacyPackages.homeConfigurations = mapUsers {
      seth = {};
    };
  };
}
