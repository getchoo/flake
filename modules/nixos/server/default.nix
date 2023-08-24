{
  config,
  lib,
  nixpkgs,
  ...
}: let
  cfg = config.server;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.server.enable = mkEnableOption "enable server configuration";

  imports = [
    ./acme.nix
    ./secrets.nix
    ./services
  ];

  config = mkIf cfg.enable {
    base = {
      enable = true;
      documentation.enable = false;
      defaultPackages.enable = false;
      networking.enable = false;
    };

    nix = {
      gc = {
        dates = "*-*-1,5,9,13,17,21,25,29 00:00:00";
        options = "-d --delete-older-than 2d";
      };

      settings.allowed-users = [config.networking.hostName];
    };

    nixpkgs.overlays = [(_: prev: {unstable = import nixpkgs {inherit (prev) system;};})];

    programs = {
      git.enable = mkDefault true;
      vim.defaultEditor = mkDefault true;
    };

    security = {
      pam.enableSSHAgentAuth = mkDefault true;
    };
  };
}
