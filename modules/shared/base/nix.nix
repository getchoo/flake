{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.base.nixSettings;
in
{
  options.base.nixSettings = {
    enable = lib.mkEnableOption "basic Nix settings" // {
      default = config.base.enable;
      defaultText = lib.literalExpression "config.base.enable";
    };

    lix.enable = lib.mkEnableOption "the use of Lix over Nix" // {
      default = isLinux;
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      package = lib.mkIf cfg.lix.enable pkgs.lix;

      settings = {
        always-allow-substitutes = true;
        auto-optimise-store = isLinux;
        experimental-features =
          [
            "nix-command"
            "flakes"
            "auto-allocate-uids"
          ]
          # TODO: remove this nonsense when all implementations remove repl-flake
          ++ lib.optional (
            lib.versionOlder config.nix.package.version "2.22.0" # repl-flake was removed in nix 2.22.0
            || lib.versionAtLeast config.nix.package.version "2.90.0" # but not in lix yet
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

    nixpkgs.config.allowUnfree = lib.mkDefault true;
  };
}
