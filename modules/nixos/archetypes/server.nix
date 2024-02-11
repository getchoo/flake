{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.archetypes.server;
in {
  options.archetypes = {
    server.enable = lib.mkEnableOption "server archetype";
  };

  config = lib.mkIf cfg.enable {
    base = {
      enable = true;
      documentation.enable = false;
      defaultPrograms.enable = false;
    };

    traits = {
      autoUpgrade.enable = true;
      cloudflared.enable = true;

      locale = {
        en_US.enable = true;
        US-east.enable = true;
      };

      nginx.defaultConfiguration = true;

      secrets.enable = true;

      tailscale = {
        enable = true;
        ssh.enable = true;
      };

      user-setup.enable = true;
      users = {
        hostUser.enable = true;
      };
    };

    _module.args.unstable = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

    boot = {
      tmp.cleanOnBoot = lib.mkDefault true;
      kernelPackages = lib.mkDefault pkgs.linuxPackages_hardened;
    };

    documentation = {
      enable = false;
      man.enable = false;
    };

    environment = {
      defaultPackages = lib.mkForce [];
      etc."nix/inputs/nixpkgs".source = inputs.nixpkgs-stable.outPath;
    };

    nix = {
      gc = {
        dates = "*-*-1,5,9,13,17,21,25,29 00:00:00";
        options = "-d --delete-older-than 2d";
      };

      registry.n.flake = inputs.nixpkgs-stable;
      settings.allowed-users = [config.networking.hostName];
    };
  };
}
