{ config, lib, ... }:
let
  cfg = config.desktop.audio;
in
{
  options.desktop.audio = {
    enable = lib.mkEnableOption "desktop audio configuration" // {
      default = config.desktop.enable;
    };
  };

  config = lib.mkIf cfg.enable {
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
