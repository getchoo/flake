{
  config,
  lib,
  ...
}:
let
  cfg = config.seth.services.spotifyd;
in
{
  options.seth.services.spotifyd = {
    enable = lib.mkEnableOption "spotifyd";
  };

  config = lib.mkIf cfg.enable {
    services.spotifyd = {
      enable = true;

      settings = {
        # Implicitly use zeroconf
        global = {
          autoplay = true;
          backend = "pulseaudio";
          bitrate = 320;
        };
      };
    };
  };
}
