{pkgs, ...}: {
  home-manager.users.seth = {
    home.packages = with pkgs; [
      discord
      iterm2
      spotify
    ];
  };

  getchoo.desktop = {
    homebrew.enable = true;
    gpg.enable = true;
  };

  networking = rec {
    computerName = "caroline";
    hostName = computerName;
  };

  nix.settings.trusted-users = ["seth"];

  services.tailscale.enable = true;
}
