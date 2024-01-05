{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # disabled since i use cloudflare tunnels
    #./acme.nix
    ./secrets.nix
  ];

  _module.args.unstable = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  boot = {
    tmp.cleanOnBoot = lib.mkDefault true;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_hardened;
  };

  documentation = {
    enable = false;
    man.enable = false;
  };

  environment.defaultPackages = lib.mkForce [];

  nix = {
    gc = {
      dates = "*-*-1,5,9,13,17,21,25,29 00:00:00";
      options = "-d --delete-older-than 2d";
    };

    settings.allowed-users = [config.networking.hostName];
  };
}
