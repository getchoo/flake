{inputs, ...}: let
  inherit (builtins) mapAttrs;
  inherit (inputs) nixpkgs hm;
  inherit (nixpkgs.lib) optional;

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
    pkgs ? nixpkgs.legacyPackages."x86_64-linux",
    extraSpecialArgs ? inputs,
    modules ? [],
  }:
    hm.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs =
        if extraSpecialArgs == inputs
        then extraSpecialArgs
        else extraSpecialArgs ++ inputs;

      modules =
        [
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
}
