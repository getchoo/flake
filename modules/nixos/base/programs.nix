{
  config,
  lib,
  ...
}: let
  cfg = config.base.defaultPrograms;
  enable = config.base.enable && cfg.enable;
in {
  config = lib.mkIf enable {
    programs = {
      git.enable = true;
      vim.defaultEditor = true;
    };
  };
}
