{ config, lib, ... }:
let
  cfg = config.desktop.homebrew;
  enable = config.desktop.enable && cfg.enable;
in
{
  options.desktop.homebrew = {
    enable = lib.mkEnableOption "Homebrew integration" // {
      default = true;
    };
  };

  config = lib.mkIf enable {
    homebrew = {
      enable = true;

      onActivation = lib.mkDefault {
        autoUpdate = true;
        cleanup = "zap";
        upgrade = true;
      };

      caskArgs = {
        no_quarantine = true;
        require_sha = false;
      };
    };
  };
}
