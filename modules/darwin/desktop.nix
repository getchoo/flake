{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
in {
  options.desktop.enable = lib.mkEnableOption "base desktop settings";

  config = lib.mkIf cfg.enable {
    fonts.fonts = with pkgs;
      lib.mkDefault [
        (nerdfonts.override {fonts = ["FiraCode"];})
      ];

    homebrew = {
      enable = lib.mkDefault true;

      onActivation = lib.mkDefault {
        autoUpdate = true;
        cleanup = "zap";
        upgrade = true;
      };

      caskArgs = {
        no_quarantine = true;
        require_sha = false;
      };

      casks = [
        "chromium"
        "iterm2"
      ];
    };

    programs.gnupg.agent.enable = lib.mkDefault true;
  };
}
