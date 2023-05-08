{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.base.nix-settings;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.base.nix-settings.enable = mkEnableOption "base nix settings";

  imports = [
    ./documentation.nix
    ./packages.nix
  ];

  config = let
    channelPath = "/etc/nix/channels/nixpkgs";
  in
    mkIf cfg.enable {
      nix = {
        package = mkDefault pkgs.nixFlakes;

        gc = {
          automatic = mkDefault true;
          dates = mkDefault "weekly";
          options = mkDefault "--delete-older-than 7d";
        };

        settings = {
          auto-optimise-store = true;
          experimental-features = ["nix-command" "flakes"];
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
