{
  homebrew.casks = ["altserver"];

  networking = rec {
    computerName = "caroline";
    hostName = computerName;
  };

  nix.settings.trusted-users = ["seth"];

  services.tailscale.enable = true;
}
