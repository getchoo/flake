{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  security = {
    apparmor.enable = mkDefault true;
    audit.enable = mkDefault true;
    auditd.enable = mkDefault true;
    polkit.enable = mkDefault true;
    rtkit.enable = mkDefault true;
    sudo.execWheelOnly = true;
  };

  services.dbus.apparmor = mkDefault "enabled";

  users = {
    defaultUserShell = pkgs.bash;
    mutableUsers = false;
  };

  nix.settings = {
    trusted-users = mkDefault ["root" "@wheel"];
  };
}
