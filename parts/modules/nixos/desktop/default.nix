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
    ./budgie
    ./fonts.nix
    ./gnome
    ./plasma
  ];

  options.desktop.enable = mkEnableOption "desktop module";

  config = mkIf cfg.enable {
    base.enable = true;
    desktop = {
      audio.enable = mkDefault true;
      fonts.enable = mkDefault true;
    };

    environment = {
      noXlibs = lib.mkForce false;
      systemPackages = with pkgs; [wl-clipboard xclip];
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
