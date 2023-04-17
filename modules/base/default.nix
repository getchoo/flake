{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.base;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.base.enable = mkEnableOption "base module";

  imports = [
    ./documentation.nix
    ./packages.nix
  ];

  config = let
    channelPath = "/etc/nix/channels/nixpkgs";
  in
    mkIf cfg.enable {
      base = {
        documentation.enable = mkDefault true;
        defaultPackages.enable = mkDefault true;
      };

      nix = {
        package = pkgs.nixFlakes;

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };

        settings = {
          auto-optimise-store = true;
          warn-dirty = false;
          experimental-features = ["nix-command" "flakes"];
          trusted-substituters = [
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };

        nixPath = [
          "nixpkgs=${channelPath}"
        ];
      };

      systemd.tmpfiles.rules = [
        "L+ ${channelPath}     - - - - ${pkgs.path}"
      ];
    };
}
