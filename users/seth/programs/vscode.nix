{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    inherit (config.desktop) enable;
    package = pkgs.vscode.fhs;
  };
}
