{lib}: rec {
  mkHMUser = {
    username,
    pkgs,
    stateVersion ? "22.11",
    modules ? [],
    inputs,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        [
          ../users/${username}/home.nix
          {
            home = {
              inherit username stateVersion;
              homeDirectory = "/home/${username}";
            };

            programs.home-manager.enable = true;
          }
        ]
        ++ modules;
    };

  mapHMUsers = inputs: system: let
    users = import ../users inputs system;
    inherit (lib.my) mapFilterDirs;
  in
    mapFilterDirs ../users (n: v: v == "directory" && n != "secrets") (username: _:
      mkHMUser ({
          inherit username inputs;
        }
        // users.${username}));
}
