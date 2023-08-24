{
  inputs,
  self,
  ...
}: let
  inherit (builtins) attrNames mapAttrs;
  inherit (inputs) nixpkgs hm;
  inherit (nixpkgs.lib) genAttrs optional;

  mkSystemCfg = name: {
    profile,
    modules ? profile.modules,
    system ? profile.system,
    specialArgs ? profile.specialArgs,
  }:
    profile.builder {
      inherit specialArgs system;
      modules =
        [../../hosts/${name}]
        ++ (
          if modules == profile.modules
          then modules
          else modules ++ profile.modules
        );
    };

  mkHMCfg = name: {
    nixpkgs ? nixpkgs,
    pkgs ? import nixpkgs {system = "x86_64-linux";},
    extraSpecialArgs ? inputs,
    modules ? [],
  }:
    hm.lib.homeManagerConfiguration {
      inherit extraSpecialArgs pkgs;

      modules =
        [
          self.homeManagerModules.${name}
          ../../users/${name}/home.nix

          {
            _module.args.osConfig = {};
            programs.home-manager.enable = true;
          }
        ]
        ++ optional pkgs.stdenv.isDarwin ../../users/${name}/darwin.nix
        ++ modules;
    };
in {
  inherit mkHMCfg mkSystemCfg;
  mapHMUsers = mapAttrs mkHMCfg;
  mapSystems = mapAttrs mkSystemCfg;

  genHMModules = users:
    genAttrs (attrNames users) (name: import ../../users/${name}/module.nix);
}
