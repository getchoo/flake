{wsl, ...}: {
  security = {
    apparmor.enable = !wsl;
    audit.enable = !wsl;
    auditd.enable = !wsl;
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
}
