{ config, lib, ... }:
let
  cfg = config.base.security;
in
{
  options.base.security = {
    enable = lib.mkEnableOption "basic security settings" // {
      default = config.base.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    security = {
      apparmor.enable = lib.mkDefault true;
      audit.enable = lib.mkDefault true;
      auditd.enable = lib.mkDefault true;
      polkit.enable = lib.mkDefault true;
      sudo.execWheelOnly = true;
    };

    services = {
      dbus.apparmor = lib.mkDefault "enabled";
    };
  };
}
