{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sbctl
    tpm2-tss
  ];

  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;

    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    supportedFilesystems = ["btrfs" "ntfs"];
  };
}
