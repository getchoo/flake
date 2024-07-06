{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.seth.programs.vscode;
in
{
  options.seth.programs.vscode = {
    enable = lib.mkEnableOption "VSCode configuration" // {
      default = config.seth.desktop.enable;
      defaultText = lib.literalExpression "config.seth.desktop.enable";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
  };
}
