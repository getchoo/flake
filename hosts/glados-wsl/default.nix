{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  environment.systemPackages = with pkgs; [
    wslu
  ];

  getchoo.base.networking.enable = false;

  wsl = {
    enable = true;
    defaultUser = "seth";
    nativeSystemd = true;
    wslConf.network = {
      hostname = "glados-wsl";
      generateResolvConf = true;
    };
    startMenuLaunchers = false;
    interop.includePath = false;
  };

  services = {
    dbus.apparmor = "disabled";
    resolved.enable = false;
  };

  networking.hostName = "glados-wsl";

  security = {
    apparmor.enable = false;
    audit.enable = false;
    auditd.enable = false;
  };

  system.stateVersion = "23.05";
}
