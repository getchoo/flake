{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.budgie;
in
{
  options.desktop.budgie.enable = lib.mkEnableOption "Budgie desktop";

  # TODO: Improve this module
  config = lib.mkIf cfg.enable {
    environment = {
      budgie.excludePackages = with pkgs; [
        qogir-theme
        qogir-icon-theme

        # I don't like MATE's apps. Fedora doesn't use them either :/
        mate.atril
        mate.pluma
        mate.engrampa
        mate.mate-calc
        mate.mate-terminal
        mate.mate-system-monitor
        vlc
      ];

      systemPackages = [
        pkgs.materia-theme
        pkgs.papirus-icon-theme

        # Replacements for mate stuff
        pkgs.celluloid
        pkgs.cinnamon.nemo-fileroller
        pkgs.evince
        pkgs.gedit
        pkgs.gnome-console
        pkgs.gnome.gnome-calculator
        pkgs.gnome.gnome-system-monitor
      ];
    };

    services.xserver = {
      # fedora uses these by default
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
        # make sure we actually use the above themes
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
