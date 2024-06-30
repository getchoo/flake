{ config, lib, ... }:
let
  cfg = config.base.defaultPrograms;
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      bash.enable = true;
      vim.enable = true;
      zsh.enable = true;
    };
  };
}
