{
  lib,
  pkgs,
  inputs,
  ...
}: {
  nix = {
    registry =
      {
        n.flake = lib.mkDefault inputs.nixpkgs;
      }
      // (builtins.mapAttrs (_: flake: {inherit flake;})
        (lib.filterAttrs (n: _: n != "nixpkgs") inputs));

    settings = {
      auto-optimise-store = pkgs.stdenv.isLinux;
      experimental-features = lib.mkDefault ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];

      trusted-substituters = lib.mkDefault ["https://cache.garnix.io"];
      trusted-public-keys = lib.mkDefault ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
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
