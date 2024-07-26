{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.seth.programs.moar;
in
{
  options.seth.programs.moar = {
    enable = lib.mkEnableOption "Moar" // {
      default = config.seth.enable;
      defaultText = lib.literalExpression "config.seth.enable";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ pkgs.moar ];
      sessionVariables = {
        MOAR = "-style catppuccin-${config.catppuccin.flavor}";
        PAGER = "moar";
      };
    };
  };
}
