{wsl, ...}: {
  security = {
    apparmor.enable = !wsl;
    audit.enable = !wsl;
    auditd.enable = !wsl;
    rtkit.enable = true;
    sudo = {
      configFile = ''
        Defaults	env_reset
        Defaults	secure_path = /run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin
        Defaults	editor = /run/current-system/sw/bin/vim,!env_editor
      '';
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
