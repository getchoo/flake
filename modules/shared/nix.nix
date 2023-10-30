{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nix = {
    registry = {
      n.flake = lib.mkDefault inputs.nixpkgs;
      self.flake = inputs.self;
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
    ];

    settings = {
      auto-optimise-store = pkgs.stdenv.isLinux;
      experimental-features = lib.mkDefault ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];

      trusted-substituters = lib.mkDefault ["https://getchoo.cachix.org"];
      trusted-public-keys = lib.mkDefault ["getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="];
      nix-path = config.nix.nixPath;
    };

    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    overlays = with inputs; [nur.overlay getchoo.overlays.default self.overlays.default];
    config.allowUnfree = lib.mkDefault true;
  };
}
