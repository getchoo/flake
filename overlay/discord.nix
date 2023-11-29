_: prev: let
  flags = "--enable-gpu-rasterization --enable-zero-copy --enable-gpu-compositing --enable-native-gpu-memory-buffers --enable-oop-rasterization --enable-features=UseSkiaRenderer,WaylandWindowDecorations";

  mkOverride = d: let
    # TODO: re-enable openASAR when gnome wayland decorations work with it
    d' = d; #.override {withOpenASAR = true;};
  in
    if prev.stdenv.isLinux
    then
      d'.overrideAttrs (old: {
        desktopItem = old.desktopItem.override (old': {
          exec = "${old'.exec} ${flags}";
        });
      })
    else d';
in {
  discord = mkOverride prev.discord;
  discord-canary = mkOverride prev.discord-canary;
}
