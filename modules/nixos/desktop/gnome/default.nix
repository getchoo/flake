{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.gnome;
in
{
  options.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop";

  config = lib.mkIf cfg.enable {
    environment = {
      gnome.excludePackages = with pkgs; [
        gnome-tour
        totem # replaced with celluloid
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      systemPackages = with pkgs; [
        adw-gtk3 # make gtk3 apps look good
        blackbox-terminal
        celluloid
      ];
    };

    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
