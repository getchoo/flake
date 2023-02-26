_: {
  imports = [
    ../common/hardware
    ../common/hardware/nvidia.nix
    ../common/virtualisation.nix
    ./boot.nix
    ./hardware-configuration.nix
    ./network.nix
    ./services.nix
  ];

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
