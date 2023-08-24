{
  config,
  lib,
  ...
}: let
  cfg = config.base.defaultPackages;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    programs.vim.enable = true;
  };
}
