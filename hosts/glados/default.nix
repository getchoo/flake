_: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ../../modules/nixos/features/tailscale.nix
    ../../modules/nixos/features/virtualisation.nix
  ];

  desktop.gnome.enable = true;
  features = {
    tailscale.enable = true;
    virtualisation.enable = true;
  };
  hardware = {
    enable = true;
    nvidia.enable = true;
  };

  environment.etc."environment".text = ''
    LIBVA_DRIVER_NAME=vdpau
  '';

  networking.hostName = "glados";
  powerManagement.cpuFreqGovernor = "ondemand";

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    swapDevices = 1;
    memoryPercent = 50;
  };
}
