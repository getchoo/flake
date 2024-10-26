{ pkgs, inputs, ... }:
{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix

    inputs.self.nixosModules.default
  ];

  archetypes.personal.enable = true;

  desktop = {
    enable = true;
    niri.enable = true;
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
      nvk.enable = false;
    };
    tailscale.enable = true;
    zram.enable = true;
  };
}
