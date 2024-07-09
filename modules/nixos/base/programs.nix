{ config, lib, ... }:
let
  cfg = config.base.defaultPrograms;
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      git.enable = true;
      vim.defaultEditor = true;
    };
  };
}
