{config, ...}: {
  programs.chromium = {
    inherit (config.desktop) enable;
    # hw accel support
    commandLineArgs = [
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-gpu-compositing"
      #"--enable-native-gpu-memory-buffers"
      "--enable-zero-copy"
      "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization,RawDraw,Vulkan,WebRTCPipeWireCapturer,WaylandWindowDecorations,WebUIDarkMode"
      "--force-dark-mode"
    ];
  };
}
