{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.programs.firefox;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.programs.firefox.enable = mkEnableOption "firefox" // {default = config.getchoo.desktop.enable;};

  imports = [
    ./arkenfox.nix
  ];

  config = mkIf cfg.enable {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };

    programs.firefox = {
      enable = true;
      profiles.arkenfox = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          floccus
          private-relay
          ublock-origin
        ];

        isDefault = true;

        settings = {
          # disable firefox accounts & pocket
          "extensions.pocket.enabled" = false;
          "identity.fxaccounts.enabled" = false;

          "gfx.webrender.all" = true;
          "fission.autostart" = true;

          # hw accel
          "media.ffmpeg.vaapi.enabled" = true;

          # widevine drm
          "media.gmp-widevinecdm.enabled" = true;
        };
      };
    };
  };
}
