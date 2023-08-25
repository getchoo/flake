{
  inputs,
  self,
  ...
}: let
  inherit (builtins) attrNames elemAt mapAttrs;
  inherit (inputs) nixpkgs hm;
  inherit (nixpkgs.lib) genAttrs optional splitString zipAttrs;

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

  genHMUsersForSys = users: system: let
    users' = users system;
    formattedUsers = map (u: "${u}@${system}") (attrNames users');
  in
    genAttrs formattedUsers (user: let
      name = elemAt (splitString "@" user) 0;
    in
      mkHMCfg name users'.${name});
in {
  inherit mkHMCfg mkSystemCfg;
  genHMUsers = users: systems: let
    zipped = zipAttrs (map (genHMUsersForSys users) systems);
  in
    mapAttrs (_: v: elemAt v 0) zipped; # why do i need to do this??? ..i'm tired

  mapSystems = mapAttrs mkSystemCfg;

  genHMModules = users:
    genAttrs (attrNames users) (name: import ../../users/${name}/module.nix);
}
