{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ./hardware-configuration.nix
    ./miniflux.nix
    ./nginx.nix
    ./teawiebot.nix
  ];

  archetypes.server.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    domain = "mydadleft.me";
    networkmanager.enable = false;
  };

  services = {
    resolved.enable = false;
    # not sure why this fails...
    # context: https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
    logrotate.checkConfig = false;
  };

  system.stateVersion = "23.05";

  zramSwap.enable = true;
}
