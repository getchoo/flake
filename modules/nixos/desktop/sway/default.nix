{
  lib,
  pkgs,
  ...
}: {
  programs.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    extraPackages = with pkgs; [
      grim
      gnome.seahorse
      libnotify
      mako
      slurp
      swaycontrib.grimshot
      swaylock
      swayidle
      swww
      waybar
      wezterm
      rofi
    ];
  };

  services = {
    gnome.gnome-keyring.enable = true;

    greetd = {
      enable = true;
      settings = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd sway";
        user = "greeter";
      };
    };
  };

  xdg.portal.wlr.enable = true;
}
