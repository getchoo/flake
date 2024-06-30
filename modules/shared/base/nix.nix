{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.base.nixSettings;
in
{
  options.base.nixSettings = {
    enable = lib.mkEnableOption "nix settings" // {
      default = config.base.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = pkgs.stdenv.isLinux;
        experimental-features = [
          "nix-command"
          "flakes"
          "auto-allocate-uids"
          "repl-flake"
        ];

        trusted-substituters = [ "https://getchoo.cachix.org" ];
        trusted-public-keys = [ "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE=" ];

        nix-path = config.nix.nixPath;
      };

      gc = {
        automatic = lib.mkDefault true;
        options = lib.mkDefault "--delete-older-than 2d";
      };
    };

    nixpkgs = {
      config.allowUnfree = lib.mkDefault true;
    };
  };
}
