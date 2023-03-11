{
  lib,
  inputs,
  mapFilterDirs,
  ...
}: rec {
  mkHMUser = {
    username,
    pkgs,
    stateVersion ? "22.11",
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ../users/${username}/home.nix
        {
          home = {
            inherit username stateVersion;
            homeDirectory = "/home/${username}";
          };

          programs.home-manager.enable = true;
        }
      ];
    };

  mapHMUsers = users:
    mapFilterDirs ../users (n: v: v == "directory" && n != "root" && n != "secrets") (username: _:
      mkHMUser {
        inherit username;
        inherit (users.${username}) pkgs stateVersion;
      });
}
