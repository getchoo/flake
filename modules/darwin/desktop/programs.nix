{ config, lib, ... }:
let
  cfg = config.desktop.defaultPrograms;
in
{
  options.desktop.defaultPrograms = {
    enable = lib.mkEnableOption "default desktop programs" // {
      default = config.desktop.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = [
      "chromium"
      "iterm2"
    ];

    programs.gnupg.agent.enable = lib.mkDefault true;
  };
}
