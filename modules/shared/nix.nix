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

      trusted-substituters = lib.mkDefault ["https://cache.mydadleft.me/getchoo"];
      trusted-public-keys = lib.mkDefault ["getchoo:rH35+W+4SV7UV9RTr69LwkH7b24Djui2ZQIQvPxzJCg="];
      nix-path = config.nix.nixPath;
    };

    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    overlays = with inputs; [getchoo.overlays.default self.overlays.default];
    config.allowUnfree = lib.mkDefault true;
  };
}
