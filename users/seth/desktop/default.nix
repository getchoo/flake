{pkgs, ...}: {
  imports = [
    ./budgie
    ./gnome
    ./plasma
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
