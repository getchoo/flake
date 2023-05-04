{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.base;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.base.enable = mkEnableOption "base module";

  imports = [
    ./documentation.nix
    ./packages.nix
  ];

  config = let
    channelPath = "/etc/nix/channels/nixpkgs";
  in
    mkIf cfg.enable {
      getchoo.base = {
        documentation.enable = mkDefault true;
        defaultPackages.enable = mkDefault true;
      };

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
