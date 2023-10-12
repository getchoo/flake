_: {
  desktop = {
    homebrew.enable = true;
    gpg.enable = true;
  };

  homebrew.casks = ["altserver"];

  networking = rec {
    computerName = "caroline";
    hostName = computerName;
  };

  nix.settings.trusted-users = ["seth"];

  services.tailscale.enable = true;
}
