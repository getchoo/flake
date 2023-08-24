{
  config,
  lib,
  ...
}: let
  cfg = config.base.defaultLocale;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    i18n = {
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
      ];

      defaultLocale = "en_US.UTF-8";
    };
  };
}
