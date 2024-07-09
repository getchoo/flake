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
  };

  # much here is sourced from https://xeiaso.net/blog/paranoid-nixos-2021-07-18/
  config = lib.mkIf cfg.enable {
    security = {
      apparmor.enable = lib.mkDefault true;
      audit.enable = lib.mkDefault true; # TODO: do i really need to set this manually?
      auditd.enable = lib.mkDefault true; # ditto
      polkit.enable = lib.mkDefault true; # ditto
      sudo.execWheelOnly = true;
    };

    services = {
      dbus.apparmor = lib.mkDefault "enabled";
    };
  };
}
