{
  flake.nixosModules = {
    archetypes = ./archetypes;
    base = ./base;
    desktop = ./desktop;
    traits = ./traits;
  };
}
