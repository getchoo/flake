{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.server;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.server.enable = mkEnableOption "enable server configuration";

  config = mkIf cfg.enable {
    base = {
      enable = true;
      documentation.enable = false;
      defaultPackages.enable = false;
    };

    environment.systemPackages = [pkgs.cachix];

    nixos = {
      enable = true;
      networking.enable = false;
    };

    networking = {
      firewall = let
        ports = [80 420];
      in {
        allowedUDPPorts = ports;
        allowedTCPPorts = ports;
      };
    };

    nix.gc.options = "--delete-older-than 7d --max-freed 50G";

    programs = {
      git.enable = mkDefault true;
      vim.defaultEditor = mkDefault true;
    };

    security = {
      pam.enableSSHAgentAuth = mkDefault true;
    };

    services = {
      endlessh = {
        enable = mkDefault true;
        port = mkDefault 22;
        openFirewall = mkDefault true;
      };

      openssh = {
        enable = true;
        passwordAuthentication = mkDefault false;
        ports = mkDefault [420];
      };
    };
  };
}
