{
  config,
  lib,
  nixpkgs,
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

    nix = {
      gc = {
        dates = "*-*-1,5,9,13,17,21,25,29 00:00:00";
        options = "-d --delete-older-than 2d";
      };

      settings = {
        trusted-substituters = [
          "https://getchoo.cachix.org"
          "https://cache.garnix.io"
          "https://nix-community.cachix.org"
          "https://wurzelpfropf.cachix.org"
        ];

        trusted-public-keys = [
          "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "wurzelpfropf.cachix.org-1:ilZwK5a6wJqVr7Fyrzp4blIEkGK+LJT0QrpWr1qBNq0="
        ];
      };
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
