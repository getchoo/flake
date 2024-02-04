{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nix = {
    registry.n.flake = lib.mkDefault inputs.nixpkgs;

    nixPath = [
      "nixpkgs=/etc/nix/inputs/nixpkgs"
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
    overlays = [inputs.self.overlays.default];
    config.allowUnfree = lib.mkDefault true;
  };
}
