{
  lib,
  inputs,
  self,
  ...
}:

lib.mapAttrs (_: file: import file { inherit lib inputs self; }) {
  builders = ./builders.nix;
  nginx = ./nginx.nix;
}
