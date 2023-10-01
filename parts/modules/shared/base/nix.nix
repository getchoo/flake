{
  config,
  inputs,
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
      registry =
        {
          n.flake = mkDefault inputs.nixpkgs;
        }
        // (builtins.mapAttrs (_: flake: {inherit flake;})
          (inputs.nixpkgs.lib.filterAttrs (n: _: n != "nixpkgs") inputs));

      settings = {
        auto-optimise-store = isLinux;
        experimental-features = ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];

        trusted-substituters = ["https://cache.garnix.io"];
        trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
      };

      gc = {
        automatic = mkDefault true;
        options = mkDefault "--delete-older-than 7d";
      };
    };

    nixpkgs = {
      overlays = with inputs; [nur.overlay getchoo.overlays.default self.overlays.default];
      config.allowUnfree = true;
    };
  };
}
