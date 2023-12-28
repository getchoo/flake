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
    toUser = name: args:
      inputs.hm.lib.homeManagerConfiguration (
        lib.recursiveUpdate
        args
        {
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
        }
      );
  in {
    legacyPackages.homeConfigurations = lib.mapAttrs toUser {
      seth = {};
    };
  };
}
