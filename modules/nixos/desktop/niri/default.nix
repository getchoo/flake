{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.niri;

  inherit (lib) version;
  minVersion = "24.11";
  hasNiri = lib.versionAtLeast version minVersion;
in
{
  options.desktop.niri = {
    enable = lib.mkEnableOption "Niri desktop settings";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment = {
          sessionVariables = {
            NIXOS_OZONE_WL = "1"; # Niri doesn't have native XWayland support
          };

          systemPackages = with pkgs; [
            alacritty # Terminal
            fuzzel # Application runner
            mako # Notification daemon
            pantheon.pantheon-agent-polkit # Polkit agent
            swaylock # Screen locker
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
      }

      # TODO: Remove when 24.11 becomes stable
      (
        if hasNiri then
          {
            programs.niri.enable = true;
          }
        else
          {
            warnings = [
              "You have enabled Niri when it is not available on NixOS ${version}. Please upgrade to at least NixOS ${minVersion}"
            ];
          }
      )
    ]
  );
}
