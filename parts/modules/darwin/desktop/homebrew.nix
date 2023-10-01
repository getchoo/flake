{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.homebrew;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.desktop.homebrew.enable = mkEnableOption "enable homebrew support";

  config = mkIf cfg.enable {
    homebrew = {
      enable = mkDefault true;
      caskArgs.require_sha = true;
      onActivation = mkDefault {
        autoUpdate = true;
        cleanup = "uninstall";
        upgrade = true;
      };

      casks = let
        # thanks @nekowinston :p
        skipSha = name: {
          inherit name;
          args = {require_sha = false;};
        };
        noQuarantine = name: {
          inherit name;
          args = {no_quarantine = true;};
        };
      in [
        "firefox"
        (lib.recursiveUpdate (noQuarantine "chromium") (skipSha "chromium"))
      ];
    };
  };
}
