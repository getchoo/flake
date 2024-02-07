{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.audio;
  enable = config.desktop.enable && cfg.enable;
in {
  options.desktop.audio = {
    enable = lib.mkEnableOption "desktop audio configuration" // {default = true;};
  };

  config = lib.mkIf enable {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services = {
      pipewire = lib.mkDefault {
        enable = true;
        wireplumber.enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };
    };
  };
}
