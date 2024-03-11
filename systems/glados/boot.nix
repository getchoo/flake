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

    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    supportedFilesystems = ["ntfs"];
  };
}
