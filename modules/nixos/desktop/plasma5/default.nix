{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.plasma5;
in {
  options.desktop.plasma5.enable = lib.mkEnableOption "Plasma 5 desktop";

  config = lib.mkIf cfg.enable {
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
