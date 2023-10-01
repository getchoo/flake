{
  lib,
  config,
  inputs,
  self,
  ...
}: let
  inherit (self.lib.configs) mapHMUsers;
  inherit (inputs) nixpkgs;

  pkgsFor = lib.genAttrs config.systems (
    system:
      import nixpkgs {
        system = "x86_64-linux";
        overlays = with inputs; [nur.overlay getchoo.overlays.default];
      }
  );
in {
  flake.homeConfigurations = mapHMUsers {
    seth.pkgs = pkgsFor."x86_64-linux";
  };
}
