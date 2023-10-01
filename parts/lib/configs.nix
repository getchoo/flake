{inputs, ...}: let
  inherit (builtins) mapAttrs;
  inherit (inputs) nixpkgs hm;

  mkSystemCfg = name: {
    profile,
    modules ? profile.modules,
    system ? profile.system,
    specialArgs ? profile.specialArgs,
  }:
    profile.builder {
      inherit specialArgs system;
      modules =
        [../systems/${name}]
        ++ (
          if modules == profile.modules
          then modules
          else modules ++ profile.modules
        );
    };

  mkHMCfg = name: {
    pkgs ? nixpkgs.legacyPackages."x86_64-linux",
    extraSpecialArgs ? {inherit inputs;},
    modules ? [],
  }:
    hm.lib.homeManagerConfiguration {
      inherit extraSpecialArgs pkgs;

      modules =
        [
          ../users/${name}/home.nix

          {
            _module.args.osConfig = {};
            programs.home-manager.enable = true;
          }
        ]
        ++ modules;
    };
in {
  mapSystems = mapAttrs mkSystemCfg;
  mapHMUsers = mapAttrs mkHMCfg;
}
