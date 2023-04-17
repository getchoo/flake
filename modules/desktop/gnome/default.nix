{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktop.gnome;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktop.gnome.enable = mkEnableOption "enable gnome";

  config = mkIf cfg.enable {
    desktop.enable = true;

    environment = {
      gnome.excludePackages = with pkgs; [
        epiphany
        gnome-tour
      ];
      systemPackages = with pkgs; [
        adw-gtk3
        blackbox-terminal
        pinentry-gnome
        pinentry-gnome
      ];
    };

    services.xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = lib.mkForce true;
      };
      desktopManager.gnome.enable = true;
    };

    programs.gnupg.agent.pinentryFlavor = "gnome3";
  };
}
