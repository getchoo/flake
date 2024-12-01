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
        # Terminal
        alacritty
        # Media player
        celluloid
        # PDF viewer
        evince
        # Application runner
        fuzzel
        # Image viewer
        loupe
        # Notification daemon
        mako
        # Polkit agent
        pantheon.pantheon-agent-polkit
        # Screen locker
        swaylock
        # Trash manager
        trashy
      ];
    };

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
