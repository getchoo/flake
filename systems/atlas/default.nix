{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
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

  networking.domain = "getchoo.com";

  system.stateVersion = "23.05";
}
