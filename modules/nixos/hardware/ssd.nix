{
  config,
  lib,
  ...
}: let
  cfg = config.hardware.ssd;
  inherit (lib) mkEnableOption mkIf;
in {
  options.hardware.ssd.enable = mkEnableOption "ssd settings";

  config = mkIf cfg.enable {
    services.fstrim.enable = true;
  };
}
