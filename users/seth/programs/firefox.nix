{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
  inherit (lib) mkIf;
in {
  config.programs.firefox = mkIf cfg.enable {
    enable = true;
    profiles.arkenfox = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        floccus
        private-relay
        ublock-origin
      ];
      isDefault = true;
    };
  };
}
