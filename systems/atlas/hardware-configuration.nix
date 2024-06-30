{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    extraModulePackages = [ ];
    kernelModules = [ ];

    initrd = {
      availableKernelModules = [
        "virtio_pci"
        "usbhid"
      ];
      kernelModules = [ ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f0c84809-83f5-414b-a973-496d25d74c6d";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/A253-0826";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];
}
