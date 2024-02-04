{
  flake.flakeModules = {
    configurations = import ./configurations.nix;
    terranix = import ./terranix.nix;
  };
}
