{
  suites.personal.enable = true;

  homebrew.casks = [
    "altserver"
    "discord"
    "spotify"
    "prismlauncher"
  ];

  networking = rec {
    computerName = "caroline";
    hostName = computerName;
  };

  nix.settings.trusted-users = ["seth"];

  services.tailscale.enable = true;

  system.stateVersion = 4;
}
