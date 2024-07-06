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
    enable = lib.mkEnableOption "basic Nix settings" // {
      default = config.base.enable;
    };

    lix.enable = lib.mkEnableOption "the use of Lix over Nix" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      package = lib.mkIf cfg.lix.enable pkgs.lix;

      settings = {
        auto-optimise-store = pkgs.stdenv.isLinux;
        experimental-features =
          [
            "nix-command"
            "flakes"
            "auto-allocate-uids"
          ]
          ++ lib.optional (
            lib.versionOlder config.nix.package.version "2.22.0" # repl-flake was removed in nix 2.22.0
            || lib.versionAtLeast config.nix.package.version "2.90.0-rc1" # but not in lix yet
          ) "repl-flake";

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
