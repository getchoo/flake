{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.audio;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktop.audio.enable = mkEnableOption "audio support";

  config = mkIf cfg.enable {
    services = {
      pipewire = {
        enable = true;
        wireplumber.enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };
    };
    hardware.pulseaudio.enable = false;
  };
}
