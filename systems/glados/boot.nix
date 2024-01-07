{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  environment.systemPackages = with pkgs; [
    sbctl
    tpm2-tss
  ];

  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = ["amd_pstate=active"];

    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.vfs_cache_pressure" = 500;
      "vm.dirty_background_ratio" = 1;
      "vm.dirty_ratio" = 50;
    };

    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    supportedFilesystems = ["btrfs" "ntfs"];
  };
}
