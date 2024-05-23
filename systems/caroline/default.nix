{config, ...}: {
  archetypes.personal.enable = true;

  homebrew.casks = [
    "altserver"
    "discord"
    "spotify"
    "prismlauncher"
  ];

  networking = {
    computerName = config.networking.hostName;
    hostName = "caroline";
  };

  nix.settings.trusted-users = ["seth"];

  services.tailscale.enable = true;

  system.stateVersion = 4;
}
