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
    enable = lib.mkEnableOption "VSCode configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
  };
}
