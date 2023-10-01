{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.programs.firefox;
  inherit (lib) genAttrs mkEnableOption mkIf recursiveUpdate;

  enableSections = sections: genAttrs sections (_: {enable = true;});
in {
  options.getchoo.programs.firefox.arkenfoxConfig.enable =
    mkEnableOption "default arkenfox config" // {default = true;};

  config.programs.firefox = mkIf (cfg.enable && cfg.arkenfoxConfig.enable) {
    arkenfox = {
      enable = true;
      version = "117.0";
    };

    profiles.arkenfox.arkenfox =
      recursiveUpdate {
        enable = true;

        # enable safe browsing
        "0400"."0403"."browser.safebrowsing.downloads.remote.enabled".value = true;

        # fix hulu
        "1200"."1201"."security.ssl.require_safe_negotiation".value = false;

        "2600"."2651"."browser.download.useDownloadDir" = {
          enable = true;
          value = true;
        };

        # disable rfp letterboxing
        "4500"."4504"."privacy.resistFingerprinting.letterboxing".value = false;

        "5000" = {
          "5003"."signon.rememberSignons".enable = true;
          # enable search autocomplete
          "5021"."keyword.enabled".value = true;
        };

        # enable drm
        "5500"."5508"."media.eme.enabled" = {
          enable = true;
          value = true;
        };
      } (enableSections [
        "0100"
        "0200"
        "0300"
        "0400"
        "0600"
        "0700"
        "0800"
        "0900"
        "1000"
        "1200"
        "1400"
        "1600"
        "1700"
        "2000"
        "2400"
        "2600"
        "2700"
        "2800"
        "4500"
      ]);
  };
}
