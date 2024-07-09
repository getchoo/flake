{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.desktop.plasma;
in
{
  options.desktop.plasma.enable = lib.mkEnableOption "Plasma desktop";

  config = lib.mkIf cfg.enable {
    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [
        khelpcenter
        plasma-browser-integration
        print-manager
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      systemPackages = [
        pkgs.haruna # mpv frontend
        inputs.krunner-nix.packages.${pkgs.system}.default # thank you leah
      ];
    };

    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      desktopManager.plasma6.enable = true;
    };
  };
}
