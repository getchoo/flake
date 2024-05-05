{
  flake = {
    darwinModules = import ./darwin;
    flakeModules = import ./flake;
    nixosModules = import ./nixos;
  };
}
