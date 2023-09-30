{
  lib,
  config,
  inputs,
  self,
  ...
}: let
  inherit (self.lib.configs) genHMModules mapHMUsers;
  pkgsFor = lib.genAttrs config.systems (system:
    import inputs.nixpkgs {
      inherit system;
      overlays = with inputs; [nur.overlay getchoo.overlays.default];
    });

  users = {
    seth = {pkgs = pkgsFor."x86_64-linux";};
  };
in {
  flake = {
    homeConfigurations = mapHMUsers users;
    homeManagerModules = genHMModules users;
  };
}
