{
  lib,
  inputs,
  self,
}:
let
  builders = import ./builders.nix { inherit lib inputs self; };
in
{
  inherit builders;

  inherit (builders)
    nixosSystem
    nixosSystemStable
    darwinSystem
    homeManagerConfiguration
    ;

  nginx = import ./nginx.nix lib;
}
