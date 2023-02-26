{
  lib,
  pkgs,
  nixpkgsStable,
  ...
}: let
  pinned-kernel = import nixpkgsStable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  environment.systemPackages = with pkgs; [
    sbctl
    tpm2-tss
  ];

  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pinned-kernel.pkgs.linuxPackages_6_1;

    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.vfs_cache_pressure" = 500;
      "vm.dirty_background_ratio" = 1;
      "vm.dirty_ratio" = 50;
    };

    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    supportedFilesystems = ["btrfs" "ntfs"];
  };
}
