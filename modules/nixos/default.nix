{
  flake.nixosModules = {
    default = ./base;
    archetypes = ./archetypes;
    desktop = ./desktop;
    traits = ./traits;
  };
}
