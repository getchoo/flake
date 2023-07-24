{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.base.defaultLocale;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.base.defaultLocale.enable = mkEnableOption "enable default locale";

  config = mkIf cfg.enable {
    time.timeZone = "America/New_York";
  };
}
