{
  nixosModules = import ./nixos;
  darwinModules = import ./darwin;
  flakeModules = import ./flake;
}
