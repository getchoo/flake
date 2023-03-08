{pkgs, ...}: {
  imports = [
    ../programs/mangohud.nix
    ../programs/firefox.nix
  ];

  home.packages = with pkgs; [
    chromium
    discord-canary
    element-desktop
    spotify
    steam
  ];
}
