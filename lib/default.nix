{
  lib,
  inputs,
  self,
  ...
}:
{
  flake.lib = lib.mapAttrs (_: file: import file { inherit lib inputs self; }) {
    nginx = ./nginx.nix;
  };
}
