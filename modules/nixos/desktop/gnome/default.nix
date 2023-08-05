{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.getchoo.desktop.gnome;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.desktop.gnome.enable = mkEnableOption "enable gnome";

  config = mkIf cfg.enable {
    getchoo.desktop.enable = true;

    environment = {
      gnome.excludePackages = with pkgs; [
        gnome-tour
      ];
      systemPackages = with pkgs; [
        adw-gtk3
        blackbox-terminal
      ];
    };

    services.xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = lib.mkForce true;
      };
      desktopManager.gnome.enable = true;
    };
  };
}
