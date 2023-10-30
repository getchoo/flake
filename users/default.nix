{
  lib,
  inputs,
  self,
  ...
}: let
  inherit (inputs.hm.lib) homeManagerConfiguration;

  /*
  basic homeManagerConfiguration wrapper. defaults to x86_64-linux
  and gives basic, nice defaults
  */
  mapUsers = lib.mapAttrs (
    name: args:
      homeManagerConfiguration (args
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

          extraSpecialArgs = {inherit inputs self;};
          pkgs = args.pkgs or inputs.nixpkgs.legacyPackages."x86_64-linux";
        })
  );
in {
  flake.homeConfigurations = mapUsers {
    seth = {};
  };
}
