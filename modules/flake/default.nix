let
  flakeModules = {
    map-configs = ./map-configs.nix;
  };
in
{
  imports = [ flakeModules.map-configs ];

  flake = {
    inherit flakeModules;
  };
}
