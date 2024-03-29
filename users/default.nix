{inputs, ...}: let
  unstableFor = inputs.nixpkgs.legacyPackages;
in {
  homeConfigurations = {
    seth = {
      pkgs = unstableFor.x86_64-linux;
    };
  };

  homeModules = {
    seth = import ./seth/module;
  };

  nixosModules = {
    seth = import ./seth/nixos.nix;
  };

  darwinModules = {
    seth = import ./seth/darwin.nix;
  };
}
