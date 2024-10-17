{ config, lib, ... }:
let
  cfg = config.traits.locale;
in
{
  options.traits.locale = {
    US-east = {
      enable = lib.mkEnableOption "eastern United States locale" // {
        default = true;
      };
    };
  };

  config = lib.mkMerge [ (lib.mkIf cfg.US-east.enable { time.timeZone = "America/New_York"; }) ];
}
