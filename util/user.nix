{home-manager, ...}: {
  mkHMUser = {
    username,
    stateVersion ? "22.11",
    system ? "x86_64-linux",
    channel,
    modules ? [],
    extraSpecialArgs ? {},
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = channel.legacyPackages.${system};
      inherit extraSpecialArgs;
      modules =
        [
          ../users/${username}/home.nix
          {
            nixpkgs.config = {
              allowUnfree = true;
              allowUnsupportedSystem = true;
            };

            nix = {
              package = channel.legacyPackages.${system}.nixFlakes;
              settings.experimental-features = ["nix-command" "flakes"];
            };

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
