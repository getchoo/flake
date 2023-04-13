{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ../../profiles/nixos
    ../../users/seth
  ];

  environment.systemPackages = with pkgs; [
    wslu
  ];

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

  services.resolved.enable = lib.mkForce false;
  security = {
    apparmor.enable = lib.mkForce false;
    audit.enable = lib.mkForce false;
    auditd.enable = lib.mkForce false;
  };

  system.stateVersion = "23.05";
}
