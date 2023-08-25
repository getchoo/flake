{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.programs.chromium;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.programs.chromium.enable = mkEnableOption "chromium" // {default = config.getchoo.desktop.enable;};

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      # hw accel support
      commandLineArgs = [
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-gpu-compositing"
        #"--enable-native-gpu-memory-buffers"
        "--enable-zero-copy"
        "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization,RawDraw,WebRTCPipeWireCapturer,Vulkan,WaylandWindowDecorations,WebUIDarkMode"
        "--enable-features=WebRTCPipeWireCapturer,WaylandWindowDecorations,WebUIDarkMode"
        "--force-dark-mode"
      ];
    };
  };
}
