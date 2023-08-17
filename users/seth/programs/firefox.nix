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

  config = mkIf cfg.enable {
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
      };
    };
  };
}
