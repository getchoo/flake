{
  lib,
  inputs,
}: let
  configs = import ./configs.nix inputs;
in
  lib.extend (_: _: {
    my = {
      inherit (configs) mkHMUser mkNixOS;

      ci = import ./ci.nix lib;

      mkFlakeFns = systems: nixpkgs: rec {
        forAllSystems = lib.genAttrs systems;
        nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
      };
    };
  })
