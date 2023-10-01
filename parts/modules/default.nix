{
  flake = {
    nixosModules.default = import ../modules/nixos;
    darwinModules.default = import ../modules/darwin;
  };
}
