{
  flake = {
    darwinModules = import ./darwin;
    nixosModules = import ./nixos;
  };
}
