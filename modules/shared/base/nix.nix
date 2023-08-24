{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.base.nix-settings;
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (pkgs.stdenv) isLinux;
in {
  options.base.nix-settings.enable = mkEnableOption "base nix settings";

  config = mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = isLinux;
        experimental-features = ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];
      };

      gc = {
        automatic = mkDefault true;
        options = mkDefault "--delete-older-than 7d";
      };
    };
  };
}
