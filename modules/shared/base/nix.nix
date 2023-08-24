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

        trusted-substituters = [
          "https://getchoo.cachix.org"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
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
