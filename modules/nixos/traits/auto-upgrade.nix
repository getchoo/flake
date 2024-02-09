{
  config,
  lib,
  ...
}: let
  cfg = config.traits.autoUpgrade;
in {
  options.traits.autoUpgrade = {
    enable = lib.mkEnableOption "automatic updates";
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;

      /*
      a workflow updates the flake every 24h at ~0:00UTC/8:00EST;
      most devices of mine will be in EST currently. this could probably be
      "01:00" or "daily" but i think that's a bit of a risk if i ever change/
      dont set the time zone for a device and forget about this lol
      */
      dates = lib.mkDefault "02:00";
      flake = "github:getchoo/flake#${config.networking.hostName}";
      flags = [
        "--refresh"
      ];
    };
  };
}
