{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.niri;
in
{
  options.desktop.niri = {
    enable = lib.mkEnableOption "Niri desktop settings";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1"; # Niri doesn't have native XWayland support
      };

      systemPackages = with pkgs; [
        alacritty
        fuzzel
        grim
        mako
        slurp
        swaylock
        xwayland-satellite
      ];
    };

    programs.niri.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session.command = toString [
          (lib.getExe pkgs.greetd.tuigreet)
          "--time"
        ];
      };
    };
  };
}
