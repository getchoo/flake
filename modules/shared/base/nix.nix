{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.base.nixSettings;

  # TODO: remove this nonsense when all implementations remove repl-flake
  hasReplFlake =
    lib.versionOlder config.nix.package.version "2.22.0" # repl-flake was removed in nix 2.22.0
    || lib.versionAtLeast config.nix.package.version "2.90.0"; # but not in lix yet

  hasAlwaysAllowSubstitutes = lib.versionAtLeast config.nix.package.version "2.19.0";
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

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        nix = {
          settings = {
            auto-optimise-store = isLinux;
            experimental-features = [
              "nix-command"
              "flakes"
              "auto-allocate-uids"
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

        nixpkgs.config.allowUnfree = lib.mkDefault true;
      }

      (lib.mkIf cfg.lix.enable {
        nix.package = pkgs.lix;
      })

      (lib.mkIf hasReplFlake {
        nix.settings.experimental-features = [ "repl-flake" ];
      })

      (lib.mkIf hasAlwaysAllowSubstitutes {
        nix.settings.always-allow-substitutes = true;
      })
    ]
  );
}
