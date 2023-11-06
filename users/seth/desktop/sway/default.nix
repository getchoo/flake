{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  enable = osConfig.programs.sway.enable or false;

  toShellVars = vars:
    lib.concatLists (
      lib.mapAttrsToList (n: v: "export ${n}=${v}") vars
    );
in {
  config = lib.mkIf enable {
    home.packages = with pkgs; [swaycontrib.grimshot];

    programs.swaylock.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      catppuccin.enable = true;
      extraOptions = ["--unsupported-gpu"];

      extraSessionCommands = toShellVars {
        SDL_VIDEODRIVER = "wayland";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOW_DECORATION = "1";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        NIXOS_OZONE_WL = "1";
      };

      wrapperFeatures = lib.genAttrs ["base" "gtk"] (lib.const true);

      systemd.xdgAutostart = true;
      xwayland = true;
    };
  };
}
