{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  enable = osConfig.services.xserver.desktopManager.plasma5.enable or false;
  themeDir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
in {
  config = lib.mkIf enable {
    home.packages = with pkgs; [
      catppuccin-cursors
      (catppuccin-kde.override
        {
          flavour = ["mocha"];
          accents = ["mauve"];
        })

      (catppuccin-kvantum.override
        {
          variant = "Mocha";
          accent = "Mauve";
        })

      libsForQt5.qtstyleplugin-kvantum
      papirus-icon-theme
    ];

    xdg = {
      configFile = {
        "gtk-4.0/gtk.css".source = "${themeDir}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${themeDir}/gtk-4.0/gtk-dark.css";
      };

      dataFile."konsole/catppuccin-mocha.colorscheme".source =
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "konsole";
          rev = "7d86b8a1e56e58f6b5649cdaac543a573ac194ca";
          sha256 = "EwSJMTxnaj2UlNJm1t6znnatfzgm1awIQQUF3VPfCTM=";
        }
        + "/Catppuccin-Mocha.colorscheme";
    };

    gtk = {
      enable = true;

      theme = {
        name = "Catppuccin-Mocha-Standard-Mauve-dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["mauve"];
          variant = "mocha";
        };
      };
    };
  };
}
