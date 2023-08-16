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
    i18n = {
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
      ];
      defaultLocale = "en_US.UTF-8";
    };

    time.timeZone = "America/New_York";
  };
}
