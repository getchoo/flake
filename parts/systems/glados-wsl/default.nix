{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ../../modules/nixos/features/tailscale.nix
  ];

  environment.systemPackages = with pkgs; [
    wslu
  ];

  base.networking.enable = false;
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

  networking.hostName = "glados-wsl";

  security = {
    apparmor.enable = false;
    audit.enable = false;
    auditd.enable = false;
  };
}
