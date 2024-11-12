{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.seth.programs.firefox;
in
{
  options.seth.programs.firefox = {
    enable = lib.mkEnableOption "Firefox configuration" // {
      default = config.seth.desktop.enable;
      defaultText = lib.literalExpression "config.seth.desktop.enable";
    };
  };

  imports = [ ./arkenfox.nix ];

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };

    programs.firefox = {
      enable = true;
      profiles.arkenfox = {
        extensions = with inputs.firefox-addons.packages.${system}; [
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
  };
}
