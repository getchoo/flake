{pkgs, ...}: {
  home-manager.users.seth = {
    home.packages = with pkgs; [
      discord-canary
      iterm2
      spotify
    ];
  };

  getchoo.desktop.homebrew.enable = true;

  networking = rec {
    computerName = "caroline";
    hostName = computerName;
  };

  nix.settings.trusted-users = ["seth"];

  services.tailscale.enable = true;
}
