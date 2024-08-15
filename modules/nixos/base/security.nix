{ config, lib, ... }:
let
  cfg = config.base.security;
in
{
  options.base.security = {
    enable = lib.mkEnableOption "basic security settings" // {
      default = config.base.enable;
      defaultText = lib.literalExpression "config.base.enable";
    };

    apparmor = lib.mkEnableOption "AppArmor support" // {
      default = true;
    };

    auditing = lib.mkEnableOption "auditing support" // {
      default = true;
    };
  };

  # much here is sourced from https://xeiaso.net/blog/paranoid-nixos-2021-07-18/
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        security = {
          polkit.enable = true;
          sudo.execWheelOnly = true;
        };
      }
      (lib.mkIf cfg.auditing {
        security = {
          audit.enable = true;
          auditd.enable = true;
        };
      })
      (lib.mkIf cfg.apparmor {
        security.apparmor.enable = true;
        services.dbus.apparmor = lib.mkDefault "enabled";
      })
    ]
  );
}
