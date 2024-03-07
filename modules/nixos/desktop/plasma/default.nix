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
    if (lib.versionAtLeast lib.version "24.05pre-git")
    then {
      environment = {
        plasma6.excludePackages = with pkgs.libsForQt5; [
          khelpcenter
          plasma-browser-integration
          print-manager
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
    else {}
  );
}
