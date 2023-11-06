{
  lib,
  pkgs,
  ...
}: {
  programs.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];

    wrapperFeatures = lib.genAttrs ["base" "gtk"] (lib.const true);

    extraPackages = with pkgs; [
      dmenu
      fuzzel
      gnome.seahorse
      libnotify
      mako
      swaycontrib.grimshot
      swaylock
      swayidle
      swww
      waybar
      wezterm
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
