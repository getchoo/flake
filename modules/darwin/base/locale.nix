{
  config,
  lib,
  ...
}: let
  cfg = config.base.defaultLocale;
  inherit (lib) mkEnableOption mkIf;
in {
  options.base.defaultLocale.enable = mkEnableOption "enable default locale";

  config = mkIf cfg.enable {
    time.timeZone = "America/New_York";
  };
}
