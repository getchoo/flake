{
  config,
  lib,
  ...
}: let
  cfg = config.traits.locale;
in {
  options.traits.locale = {
    en_US = {
      enable = lib.mkEnableOption "en_US locale";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.en_US.enable {
      i18n = {
        supportedLocales = [
          "en_US.UTF-8/UTF-8"
        ];

        defaultLocale = "en_US.UTF-8";
      };
    })
  ];
}
