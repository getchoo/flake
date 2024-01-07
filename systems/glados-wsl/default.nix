{
  lib,
  modulesPath,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")

    inputs.nixos-wsl.nixosModules.wsl

    ../../modules/nixos/features/tailscale.nix
  ];

  documentation = {
    enable = lib.mkForce true;
    man.enable = lib.mkForce true;
  };

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

  # doesn't work on wsl
  services.dbus.apparmor = "disabled";

  networking = {
    hostName = "glados-wsl";
    # ditto
    networkmanager.enable = false;
  };

  # ditto
  security = {
    apparmor.enable = false;
    audit.enable = false;
    auditd.enable = false;
  };

  # ditto
  services.resolved.enable = false;

  system.stateVersion = "23.11";
}
