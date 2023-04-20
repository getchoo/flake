{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktop.budgie;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktop.budgie.enable = mkEnableOption "enable budgie";

  config = mkIf cfg.enable {
    services.xserver = {
      displayManager.lightdm.greeters.slick = {
        theme = {
          name = "Materia-dark";
          package = pkgs.materia-theme;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          name = "Breeze-gtk";
          package = pkgs.libsForQt5.breeze-gtk;
        };
      };

      desktopManager.budgie = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.desktop.interface:Budgie]
          gtk-theme="Materia-dark"
          icon-theme="Papirus-Dark"
          cursor-theme="Breeze-gtk"
          font-name="Noto Sans 10"
          document-font-name="Noto Sans 10"
          monospace-font-name="Fira Code 10"
          enable-hot-corners=true
        '';
      };
    };

    environment.budgie.excludePackages = with pkgs; [
      qogir-theme
      qogir-icon
    ];

    environment.systemPackages = with pkgs; [
      alacritty
      breeze-gtk
      materia-theme
      papirus-icon-theme
    ];
  };
}
