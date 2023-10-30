{
  config,
  pkgs,
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
}
