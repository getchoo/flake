{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
  inherit (lib) mkEnableOption mkIf;
in {
  imports = [
    ./budgie
    ./gnome
    ./plasma
    ../programs/mangohud.nix
    ../programs/firefox.nix
  ];

  options.desktop.enable = mkEnableOption "enable desktop configuration";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      element-desktop
      spotify
      steam
      prismlauncher
    ];

    programs = {
      chromium = {
        enable = true;
        # hw accel support
        commandLineArgs = [
          "--ignore-gpu-blocklist"
          "--enable-gpu-rasterization"
          "--enable-gpu-compositing"
          "--enable-native-gpu-memory-buffers"
          "--enable-zero-copy"
          "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization,RawDraw,WebRTCPipeWireCapturer,Vulkan,WaylandWindowDecorations,WebUIDarkMode"
          "--force-dark-mode"
        ];
      };
    };
  };
}
