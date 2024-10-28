# Much of this is sourced from https://xeiaso.net/blog/paranoid-nixos-2021-07-18/
{ lib, ... }:
{
  security = {
    apparmor.enable = lib.mkDefault true;
    audit.enable = lib.mkDefault true;
    auditd.enable = lib.mkDefault true;
    polkit.enable = true;
    sudo.execWheelOnly = true;
  };

  services.dbus.apparmor = lib.mkDefault "enabled";
}
