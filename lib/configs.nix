inputs: {
  mkNixOS = {
    name,
    profile,
    modules ? profile.modules,
    system ? profile.system,
    specialArgs ? profile.specialArgs,
  }:
    profile.builder {
      inherit specialArgs system;
      modules =
        [../hosts/${name}]
        ++ (
          if modules == profile.modules
          then modules
          else modules ++ profile.modules
        );
    };

  mkHMUser = {
    name,
    modules ? [],
    pkgs ? import inputs.nixpkgs {system = "x86_64-linux";},
    extraSpecialArgs ? inputs,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs;
      modules =
        [
          {
            programs.home-manager.enable = true;
          }
        ]
        ++ [../users/${name}/home.nix]
        ++ modules;
    };
}
