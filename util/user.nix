{ home-manager, ... }: {
  mkHMUser =
    { username
    , stateVersion ? "22.11"
    , system ? "x86_64-linux"
    , channel
    , modules ? [ ]
    ,
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = channel.legacyPackages.${system};
      modules =
        [
          ../users/${username}/home.nix
          {
            nixpkgs.config.allowUnfree = true;
            systemd.user.startServices = true;
            home = {
              inherit username stateVersion;
              homeDirectory = "/home/${username}";
            };
            programs.home-manager.enable = true;
          }
        ]
        ++ modules;
    };
}
