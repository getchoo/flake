{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.defaultPrograms;
  enable = config.desktop.enable && cfg.enable;
in {
  options.desktop.defaultPrograms = {
    enable = lib.mkEnableOption "default desktop programs" // {default = true;};
  };

  config = lib.mkIf enable {
    homebrew.casks = [
      "chromium"
      "iterm2"
    ];
    programs.gnupg.agent.enable = lib.mkDefault true;
  };
}
