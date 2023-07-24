{pkgs, ...}: {
  imports = [
    ../../users/seth
  ];

  home-manager.users.seth = {
    imports = [
      ../../users/seth/programs/firefox.nix
    ];

    home.packages = with pkgs; [
      discord-canary
      iterm2
      spotify
    ];
  };

  networking = rec {
    computerName = "caroline";
    hostName = computerName;
  };

  nix.settings.trusted-users = ["seth"];

  services.tailscale.enable = true;
}
