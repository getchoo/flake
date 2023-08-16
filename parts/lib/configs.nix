{inputs, ...}: let
  inherit (builtins) attrNames elemAt map;
  inherit (inputs.nixpkgs.lib) flatten genAttrs optional splitString;

  archs = ["x86_64" "aarch64"];
  os' = ["linux" "darwin"];
  mkSystems = systems: flatten (map (sys: map (arch: ["${arch}-${sys}" "${arch}-${sys}"]) archs) systems);
  systems = mkSystems os';

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
in {
  inherit mkSystemCfg;
  mapSystems = builtins.mapAttrs mkSystemCfg;

  genHMCfgs = users: let
    names = flatten (map (user: map (system: "${user}@${system}") systems) (attrNames users));
  in
    genAttrs names (name: let
      getPart = elemAt (splitString "@" name);
      username = getPart 0;
      system = getPart 1;
    in
      inputs.home-manager.lib.homeManagerConfiguration rec {
        pkgs = import (users.${username}.nixpkgs or inputs.nixpkgs) (
          {inherit system;} // users.${username}.nixpkgsArgs or {}
        );

        extraSpecialArgs = users.${username}.extraSpecialArgs or inputs;

        modules =
          [
            {
              _module.args.osConfig = {};
              programs.home-manager.enable = true;
            }
            ../../users/${username}/home.nix
          ]
          ++ optional pkgs.stdenv.isDarwin ../../users/${username}/darwin.nix
          ++ users.${username}.modules or [];
      });
}
