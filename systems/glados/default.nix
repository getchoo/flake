{ pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
  ];

  archetypes.personal.enable = true;

  desktop = {
    enable = true;
    plasma.enable = true;
  };

  environment.systemPackages = [ pkgs.obs-studio ];

  networking.hostName = "glados";

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services = {
    flatpak.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
  };

  system.stateVersion = "23.11";

  traits = {
    containers.enable = true;
    nvidia = {
      enable = true;
      nvk.enable = true;
    };
    tailscale.enable = true;
    zram.enable = true;
  };
}
