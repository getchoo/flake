{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../nixos
    ./fonts.nix
  ];
  environment = {
    noXlibs = lib.mkForce false;
    systemPackages = with pkgs; [pinentry-curses];
  };
  programs = {
    dconf.enable = true;
    firefox.enable = true;
    xwayland.enable = true;
  };
  services.xserver.enable = true;
  xdg.portal.enable = true;
}
