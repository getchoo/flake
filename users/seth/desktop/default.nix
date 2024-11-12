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
    enable = lib.mkEnableOption "desktop (Linux) settings" // {
      default = osConfig.desktop.enable or false;
      defaultText = lib.literalExpression "osConfig.desktop.enable or false";
    };
  };

  imports = [
    ./budgie
    ./gnome
    ./niri
    ./plasma
  ];

  config = lib.mkIf cfg.enable {
    # This is meant for Linux
    assertions = [ (lib.hm.assertions.assertPlatform "seth.desktop" pkgs lib.platforms.linux) ];

    home.packages = [

      # Add hardware acceleration flags on Linux
      ## let
      ##   inherit (pkgs) discord;
      ##   flags = lib.concatStringsSep " " [
      ##     "--enable-gpu-rasterization"
      ##     "--enable-zero-copy"
      ##     "--enable-gpu-compositing"
      ##     "--enable-native-gpu-memory-buffers"
      ##     "--enable-oop-rasterization"
      ##     "--enable-features=UseSkiaRenderer,WaylandWindowDecorations"
      ##   ];
      ## in
      ## if pkgs.stdenv.isLinux then
      ##   discord.overrideAttrs (old: {
      ##     desktopItem = old.desktopItem.override (old': {
      ##       exec = "${old'.exec} ${flags}";
      ##     });
      ##   })
      ## else
      pkgs.discord

      pkgs.prismlauncher
    ];
  };
}
