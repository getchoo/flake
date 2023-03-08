{
  lib,
  pkgs,
  ...
}: {
  security = {
    apparmor.enable = lib.mkDefault true;
    audit.enable = lib.mkDefault true;
    auditd.enable = lib.mkDefault true;
    rtkit.enable = true;
    sudo = {
      execWheelOnly = true;
      extraRules = [
        {
          users = ["root"];
          groups = ["root"];
          commands = ["ALL"];
        }
        {
          users = ["seth"];
          commands = ["ALL"];
        }
      ];
    };
    polkit.enable = true;
  };

  users = {
    defaultUserShell = pkgs.bash;
    mutableUsers = false;
  };
}
