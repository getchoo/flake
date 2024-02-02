{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.budgie;
in {
  options.desktop.budgie.enable = lib.mkEnableOption "budgie desktop";

  config = lib.mkIf cfg.enable {
    environment = {
      budgie.excludePackages = with pkgs; [
        qogir-theme
        qogir-icon-theme

        # i don't like mates apps. fedora doesn't use them either :/
        mate.atril
        mate.pluma
        mate.engrampa
        mate.mate-calc
        mate.mate-terminal
        mate.mate-system-monitor
        vlc
      ];

      systemPackages = with pkgs; [
        materia-theme
        papirus-icon-theme

        # replacements for mate stuff
        evince
        gedit
        cinnamon.nemo-fileroller
        gnome.gnome-calculator
        blackbox-terminal
        gnome.gnome-system-monitor
        celluloid
      ];
    };

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
      };

      desktopManager.budgie = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.desktop.interface:Budgie]
          color-scheme='prefer-dark'
          gtk-theme='Materia-dark'
          icon-theme='Papirus-Dark'
        '';
      };
    };
  };
}
