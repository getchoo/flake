{pkgs, ...}: {
  home.packages = with pkgs; [adw-gtk3] ++ (with pkgs.gnomeExtensions; [appindicator blur-my-shell caffeine]);

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
      ];
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "discord-canary.desktop"
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

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };

  xdg.dataFile."blackbox/schemes/Catppuccin-Mocha.json" = {
    text = ''
      {
        "name": "Catppuccin-Mocha",
        "comment": "Soothing pastel theme for the high-spirited!",
        "background-color": "#1E1E2E",
        "foreground-color": "#CDD6F4",
        "badge-color": "#585B70",
        "bold-color": "#585B70",
        "cursor-background-color": "#F5E0DC",
        "cursor-foreground-color": "#1E1E2E",
        "highlight-background-color": "#F5E0DC",
        "highlight-foreground-color": "#1E1E2E",
        "palette": [
          "#45475A",
          "#F38BA8",
          "#A6E3A1",
          "#F9E2AF",
          "#89B4FA",
          "#F5C2E7",
          "#94E2D5",
          "#BAC2DE",
          "#585B70",
          "#F38BA8",
          "#A6E3A1",
          "#F9E2AF",
          "#89B4FA",
          "#F5C2E7",
          "#94E2D5",
          "#A6ADC8"
        ],
        "use-badge-color": false,
        "use-bold-color": false,
        "use-cursor-color": true,
        "use-highlight-color": true,
        "use-theme-colors": false
      }
    '';
  };
}
