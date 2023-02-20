{ config
, lib
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = [ "nohibernate" ];

    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    supportedFilesystems = [ "zfs" "ntfs" ];
  };
}
