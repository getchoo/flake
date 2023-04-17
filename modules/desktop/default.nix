{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./gnome
    ./plasma
  ];

  options.desktop.enable = mkEnableOption "desktop module";

  config = mkIf cfg.enable {
    nixos.enable = true;

    desktop = {
      audio.enable = mkDefault true;
      fonts.enable = mkDefault true;
    };

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
  };
}
