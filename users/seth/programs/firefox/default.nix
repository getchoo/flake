{
  config,
  inputs',
  ...
}: {
  imports = [
    ./arkenfox.nix
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.firefox = {
    inherit (config.desktop) enable;
    profiles.arkenfox = {
      extensions = with inputs'.firefox-addons.packages; [
        bitwarden
        floccus
        ublock-origin
      ];

      isDefault = true;

      settings = {
        # disable firefox accounts & pocket
        "extensions.pocket.enabled" = false;
        "identity.fxaccounts.enabled" = false;

        # hw accel
        "media.ffmpeg.vaapi.enabled" = true;

        # widevine drm
        "media.gmp-widevinecdm.enabled" = true;
      };
    };
  };
}
