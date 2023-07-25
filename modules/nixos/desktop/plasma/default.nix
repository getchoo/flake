{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.desktop.plasma;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.desktop.plasma.enable = mkEnableOption "enable plasma";

  config = mkIf cfg.enable {
    getchoo.desktop.enable = true;

    environment = {
      plasma5.excludePackages = with pkgs.libsForQt5; [
        khelpcenter
        plasma-browser-integration
        print-manager
      ];
    };

    services.xserver = {
      displayManager.sddm.enable = true;
      desktopManager.plasma5 = {
        enable = true;
        useQtScaling = true;
      };
    };
  };
}
