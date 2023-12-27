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
            inherit inputs inputs' self;
          };

          pkgs = args.pkgs or inputs.nixpkgs.legacyPackages."x86_64-linux";
        });

    mapUsers = lib.mapAttrs mkUser;
  in {
    legacyPackages.homeConfigurations = mapUsers {
      seth = {};
    };
  };
}
