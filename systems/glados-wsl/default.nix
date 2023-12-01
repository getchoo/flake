{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ../../modules/nixos/features/tailscale.nix
  ];

  environment = {
    noXlibs = lib.mkForce false;
    systemPackages = with pkgs; [
      wget
      wslu
    ];
  };

  features.tailscale.enable = true;

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

  services.dbus.apparmor = "disabled";

  networking = {
    hostName = "glados-wsl";
    networkmanager.enable = false;
  };

  security = {
    apparmor.enable = false;
    audit.enable = false;
    auditd.enable = false;
  };

  services.resolved.enable = false;
}
