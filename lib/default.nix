{
  lib,
  ...
}:
{
  flake.lib = {
    nginx = import ./nginx.nix lib;
  };
}
