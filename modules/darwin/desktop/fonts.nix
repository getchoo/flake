{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.fonts;
  enable = config.desktop.enable && cfg.enable;
in {
  options.desktop.fonts = {
    enable = lib.mkEnableOption "desktop fonts" // {default = true;};
  };

  config = lib.mkIf enable {
    fonts.packages = [
      (pkgs.nerdfonts.override {fonts = ["FiraCode"];})
    ];
  };
}
