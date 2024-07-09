{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = with pkgs; [
    # manual lanzaboote maintenance (NOTE: i have not actually used this since ~2022)
    sbctl
    # TODO: is this actually required for using `tpm2-device=auto` to unlock LUKS volumes in initrd? probably
    tpm2-tss
  ];

  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [ "amd_pstate=active" ];

    # lanzaboote replaces this
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # for game drive
    supportedFilesystems = [ "ntfs" ];
  };
}
