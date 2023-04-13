{
  inputs,
  mapFilterDirs,
}: rec {
  mkHMUser = {
    username,
    pkgs,
    stateVersion ? "22.11",
    modules ? [],
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

  mapHMUsers = users:
    mapFilterDirs ../users (n: v: v == "directory" && n != "root" && n != "secrets") (username: _:
      mkHMUser {
        inherit username;
        inherit (users.${username}) pkgs stateVersion;
        modules =
          if builtins.hasAttr "modules" users.${username}
          then users.${username}.modules
          else {};
      });
}
