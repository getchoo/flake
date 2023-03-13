{
  lib,
  pkgs,
  ...
}: {
  security = {
    apparmor.enable = lib.mkDefault true;
    audit.enable = lib.mkDefault true;
    auditd.enable = lib.mkDefault true;
    polkit.enable = true;
    rtkit.enable = true;
    sudo.execWheelOnly = true;
  };

  users = {
    defaultUserShell = pkgs.bash;
    mutableUsers = false;
  };

  nix.settings = {
    allowed-users = ["root" "@wheel"];
    trusted-users = ["root"];
  };
}
