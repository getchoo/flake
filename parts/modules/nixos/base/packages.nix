{
  config,
  lib,
  ...
}: let
  cfg = config.base.defaultPackages;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    programs = {
      git.enable = true;
      vim.defaultEditor = true;
    };
  };
}
