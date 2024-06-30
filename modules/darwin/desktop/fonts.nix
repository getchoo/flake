{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.fonts;
in
{
  options.desktop.fonts = {
    enable = lib.mkEnableOption "desktop fonts" // {
      default = config.desktop.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  };
}
