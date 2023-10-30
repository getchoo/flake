{lib, ...}: {
  imports = [
    ./ssd.nix
    ./nvidia.nix
  ];

  hardware.enableAllFirmware = lib.mkDefault true;
}
