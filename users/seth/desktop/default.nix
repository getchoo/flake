{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = config.seth.desktop;
in
{
  options.seth.desktop = {
    enable = lib.mkEnableOption "desktop" // {
      default = osConfig.desktop.enable or false;
    };
  };

  imports = [
    ./budgie
    ./gnome
    ./plasma
  ];

  config = lib.mkIf cfg.enable {
    home.packages = [
      (
        let
          inherit (pkgs) discord;
          flags = lib.concatStringsSep " " [
            "--enable-gpu-rasterization"
            "--enable-zero-copy"
            "--enable-gpu-compositing"
            "--enable-native-gpu-memory-buffers"
            "--enable-oop-rasterization"
            "--enable-features=UseSkiaRenderer,WaylandWindowDecorations"
          ];
        in
        if pkgs.stdenv.isLinux then
          discord.overrideAttrs (old: {
            desktopItem = old.desktopItem.override (old': {
              exec = "${old'.exec} ${flags}";
            });
          })
        else
          discord
      )

      pkgs.element-desktop
      pkgs.spotify
      (pkgs.prismlauncher.override { withWaylandGLFW = true; })
    ];
  };
}
