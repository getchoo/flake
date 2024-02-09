{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.base.nixSettings;
  enable = config.base.enable && cfg.enable;
in {
  options.base.nixSettings = {
    enable = lib.mkEnableOption "nix settings" // {default = true;};
  };

  config = lib.mkIf enable {
    nix = {
      registry.n.flake = lib.mkDefault inputs.nixpkgs;

      nixPath = [
        "nixpkgs=/etc/nix/inputs/nixpkgs"
      ];

      settings = {
        auto-optimise-store = pkgs.stdenv.isLinux;
        experimental-features = ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];

        trusted-substituters = ["https://cache.garnix.io"];
        trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
        nix-path = config.nix.nixPath;
      };

      gc = {
        automatic = lib.mkDefault true;
        options = lib.mkDefault "--delete-older-than 7d";
      };
    };

    nixpkgs = {
      overlays = [inputs.self.overlays.default];
      config.allowUnfree = lib.mkDefault true;
    };
  };
}
