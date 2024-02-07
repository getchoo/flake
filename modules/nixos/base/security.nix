{
  config,
  lib,
  ...
}: let
  cfg = config.base.security;
  enable = config.base.enable && cfg.enable;
in {
  options.base.security = {
    enable = lib.mkEnableOption "base security settings" // {default = true;};
  };

  config = lib.mkIf enable {
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
