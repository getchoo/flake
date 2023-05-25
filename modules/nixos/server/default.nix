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

    nix = {
      gc = {
        dates = "4d";
        options = "--delete-older-than 7d --max-freed 50G";
      };

      settings = {
        trusted-users = ["${config.networking.hostName}"];
        trusted-substituters = [
          "https://getchoo.cachix.org"
          "https://nix-community.cachix.org"
          "https://wurzelpfropf.cachix.org"
        ];

        trusted-public-keys = [
          "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
      fail2ban = {
        enable = true;
        bantime-increment = {
          enable = true;
        };
        maxretry = 5;
      };

      openssh = {
        enable = true;
        passwordAuthentication = mkDefault false;
      };
    };
  };
}
