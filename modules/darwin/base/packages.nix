{
  config,
  lib,
  ...
}: let
  cfg = config.base.defaultPackages;
  inherit (lib) mkEnableOption mkIf;
in {
  options.base.defaultPackages.enable = mkEnableOption "base module default packages";

  config = mkIf cfg.enable {
    programs = {
      vim.enable = true;
    };
  };
}
