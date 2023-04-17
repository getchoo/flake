{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.plasma;
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktop.plasma.enable = mkEnableOption "enable plasma";

  config = mkIf cfg.enable {
    desktop.enable = true;

    environment.systemPackages = with pkgs; [pinentry-qt];

    services.xserver = {
      displayManager.sddm.enable = true;
      desktopManager.plasma5 = {
        enable = true;
        excludePackages = with pkgs.libsForQt5; [
          khelpcenter
          plasma-browser-integration
          print-manager
        ];
        useQtScaling = true;
      };
    };

    programs.gnupg.agent.pinentryFlavor = "qt";
  };
}
