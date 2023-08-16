{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.desktop;
  inherit (lib) mkEnableOption mkIf;

  desktops = ["budgie" "gnome" "plasma"];
in {
  imports = [
    ./budgie
    ./gnome
    ./plasma
    ../programs/mangohud.nix
    ../programs/firefox.nix
  ];

  options.desktop.enable = mkEnableOption "desktop configuration" // {default = osConfig.desktop.enable or false;};

  config = mkIf cfg.enable {
    desktop = lib.genAttrs desktops (desktop: {enable = osConfig.desktop.${desktop}.enable or false;});

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
