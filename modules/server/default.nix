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
      documentation.enable = mkDefault false;
      defaultPackages.enable = mkDefault false;
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
      git.enable = true;
      vim.defaultEditor = true;
    };

    security = {
      pam.enableSSHAgentAuth = true;
    };

    services = {
      endlessh = {
        enable = true;
        port = 22;
        openFirewall = true;
      };

      openssh = {
        enable = true;
        passwordAuthentication = false;
        ports = [420];
      };
    };
  };
}
