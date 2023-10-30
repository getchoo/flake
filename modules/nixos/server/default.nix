{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./acme.nix
    ./secrets.nix
  ];

  _module.args.unstable = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  documentation = {
    enable = false;

    man = {
      enable = false;
      man-db.enable = false;
    };

    nixos.enable = false;
    dev.enable = false;
  };

  environment.defaultPackages = lib.mkForce [];

  nix = {
    gc = {
      dates = "*-*-1,5,9,13,17,21,25,29 00:00:00";
      options = "-d --delete-older-than 2d";
    };

    settings.allowed-users = [config.networking.hostName];
  };

  security.pam.enableSSHAgentAuth = true;
}
