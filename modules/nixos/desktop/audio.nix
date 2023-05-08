{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.desktop.audio;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.desktop.audio.enable = mkEnableOption "enable audio support";

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
