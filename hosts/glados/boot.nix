{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot = {
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
