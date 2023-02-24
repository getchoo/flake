_: {
  imports = [
    ../common/hardware
    ../common/hardware/nvidia.nix
    ./boot.nix
    ./hardware-configuration.nix
    ./network.nix
    ./services.nix
  ];
}
