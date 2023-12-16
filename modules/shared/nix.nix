{
  config,
  lib,
  pkgs,
  inputs,
  self,
  ...
}: {
  nix = {
    registry = {
      n.flake = lib.mkDefault inputs.nixpkgs;
      self.flake = self;
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
    ];

    settings = {
      auto-optimise-store = pkgs.stdenv.isLinux;
      experimental-features = lib.mkDefault ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];

      trusted-substituters = lib.mkDefault ["https://cache.garnix.io"];
      trusted-public-keys = lib.mkDefault ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
      nix-path = config.nix.nixPath;
    };

    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    overlays = [self.overlays.default];
    config.allowUnfree = lib.mkDefault true;
  };
}
