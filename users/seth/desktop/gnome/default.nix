{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.gnome;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktop.gnome.enable = mkEnableOption "enable gnome";

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [adw-gtk3]
      ++ (with pkgs.gnomeExtensions; [
        appindicator
        blur-my-shell
        caffeine
        clipboard-history
        gradience
      ]);

    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "caffeine@patapon.info"
            "clipboard-history@alexsaveau.dev"
          ];
          favorite-apps = [
            "firefox.desktop"
            "org.gnome.Nautilus.desktop"
            "discord.desktop"
          ];
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          font-antialiasing = ''rgba'';
          font-name = ''Noto Sans 11'';
          document-font-name = ''Noto Sans 11'';
          monospace-font-name = ''FiraCode Nerd Font 10'';
        };
        "org/gnome/desktop/peripherals/mouse" = {
          accel-profile = ''flat'';
        };
        "org/gnome/desktop/wm/preferences" = {
          titlebar-font = ''Noto Sans Bold 11'';
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-windows = ["<Alt>Tab"];
          switch-windows-backward = ["<Shift><Alt>Tab"];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "blackbox";
          command = "blackbox";
          binding = "<Control><Alt>t";
        };
        "com/raggesilver/BlackBox" = {
          font = ''FiraCode Nerd Font 12'';
          theme-dark = ''Catppuccin-Mocha'';
          remember-window-size = true;
        };
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
    };

    xdg.dataFile."blackbox/schemes/Catppuccin-Mocha.json".source =
      pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "tilix";
        rev = "3fd05e03419321f2f2a6aad6da733b28be1765ef";
        sha256 = "sha256-SI7QxQ+WBHzeuXbTye+s8pi4tDVZOV4Aa33mRYO276k=";
      }
      + "/src/Catppuccin-Mocha.json";
  };
}
