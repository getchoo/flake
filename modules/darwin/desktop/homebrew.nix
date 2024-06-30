{ config, lib, ... }:
let
  cfg = config.desktop.homebrew;
in
{
  options.desktop.homebrew = {
    enable = lib.mkEnableOption "Homebrew integration" // {
      default = config.desktop.enable;
    };
  };

  config = lib.mkIf cfg.enable {
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
