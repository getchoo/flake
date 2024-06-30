{ config, lib, ... }:
let
  cfg = config.base.defaultPrograms;
  enable = config.base.enable && cfg.enable;
in
{
  config = lib.mkIf enable {
    programs = {
      bash.enable = true;
      vim.enable = true;
      zsh.enable = true;
    };
  };
}
