{config, ...}: {
  gtk = {
    enable = true;
    catppuccin.enable = true;
  };

  xdg.configFile = let
    gtk4Dir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
  in {
    "gtk-4.0/assets" = {
      source = "${gtk4Dir}/assets";
      recurisve = true;
    };
    "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
  };
}
