{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../nixos
    ./fonts.nix
    ./network.nix
    ./services.nix
  ];
  environment = {
    noXlibs = lib.mkForce false;
    systemPackages = with pkgs; [pinentry-curses wl-clipboard xclip];
  };
  programs = {
    dconf.enable = true;
    firefox.enable = true;
    xwayland.enable = true;
  };
  services.xserver.enable = true;
  xdg.portal.enable = true;
}
