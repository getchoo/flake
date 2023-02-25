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
  ];

  boot = {
    kernelPackages = pinned-kernel.pkgs.linuxPackages_6_1;

    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    supportedFilesystems = ["btrfs" "ntfs"];
  };
}
