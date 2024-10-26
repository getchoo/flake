{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  enable = osConfig.services.xserver.desktopManager.gnome.enable or false;
in
{
  config = lib.mkIf enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;

          enabled-extensions = [ "caffeine@patapon.info" ];

          favorite-apps = [
            "chromium-browser.desktop"
            "org.gnome.Nautilus.desktop"
            "discord.desktop"
          ];
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          document-font-name = "Noto Sans 11";
          font-antialiasing = "rgba";
          font-name = "Noto Sans 11";
          monospace-font-name = "NotoMono Nerd Font 10";
        };

        "org/gnome/desktop/peripherals/mouse" = {
          accel-profile = "flat";
        };

        "org/gnome/desktop/wm/preferences" = {
          titlebar-font = "Noto Sans Bold 11";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "blackbox";
          command = "blackbox";
          binding = "<Control><Alt>t";
        };

        "com/raggesilver/BlackBox" = {
          font = "NotoMono Nerd Font 11";
          theme-dark = "Catppuccin-Mocha";
          remember-window-size = true;
        };
      };
    };

    # Required for adwaita-ize
    gtk.enable = true;

    home.packages = [
      pkgs.gnomeExtensions.caffeine
      pkgs.tuba
    ];

    seth.tweaks.adwaita-ize.enable = true;

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
