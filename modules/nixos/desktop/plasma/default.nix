{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.plasma;
in {
  options.desktop.plasma.enable = lib.mkEnableOption "Plasma desktop";

  config = lib.mkIf cfg.enable (
    # this is bad, i don't care
    lib.optionalAttrs (lib.versionAtLeast lib.version "24.05pre-git") {
      environment = {
        plasma6.excludePackages = with pkgs.kdePackages; [
          khelpcenter
          plasma-browser-integration
          print-manager
        ];

        sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };

        systemPackages = with pkgs; [
          haruna
        ];
      };

      services.xserver = {
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };

        desktopManager.plasma6 = {
          enable = true;
          enableQt5Integration = true;
        };
      };
    }
  );
}
