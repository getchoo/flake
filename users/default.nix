{
  inputs,
  self,
  ...
}: let
  unstableFor = inputs.nixpkgs.legacyPackages;
in {
  flake = {
    homeConfigurations = self.lib.configs.mapUsers {
      seth = {
        pkgs = unstableFor.x86_64-linux;
      };
    };
  };
}
