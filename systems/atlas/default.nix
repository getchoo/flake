{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/hardened.nix")
    ./hardware-configuration.nix
    ./miniflux.nix
    ./nginx.nix
    ./teawiebot.nix
  ];

  archetypes.server.enable = true;
  base.networking.enable = false;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.domain = "mydadleft.me";

  # not sure why this fails...
  # context: https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  services.logrotate.checkConfig = false;

  system.stateVersion = "23.05";

  zramSwap.enable = true;
}
