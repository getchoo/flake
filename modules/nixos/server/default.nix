{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.server;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.server.enable = mkEnableOption "enable server configuration";

  imports = [
    ./secrets.nix
    ./services
  ];

  config = mkIf cfg.enable {
    getchoo.base = {
      enable = true;
      documentation.enable = false;
      defaultPackages.enable = false;
      networking.enable = false;
    };

    environment.systemPackages = [pkgs.cachix];

    networking = {
      firewall = let
        ports = [80 420];
      in {
        allowedUDPPorts = ports;
        allowedTCPPorts = ports;
      };
    };

    nix = {
      gc.options = "--delete-older-than 7d --max-freed 50G";
      settings = {
        trusted-users = ["${config.networking.hostName}"];
        trusted-substituters = [
          "https://getchoo.cachix.org"
          "https://nix-community.cachix.org"
          "https://hercules-ci.cachix.org"
          "https://wurzelpfropf.cachix.org"
        ];

        trusted-public-keys = [
          "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
          "wurzelpfropf.cachix.org-1:ilZwK5a6wJqVr7Fyrzp4blIEkGK+LJT0QrpWr1qBNq0="
        ];
      };
    };

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
