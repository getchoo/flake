{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.base.defaultPackages;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.base.defaultPackages.enable = mkEnableOption "base module default packages";

  config = mkIf cfg.enable {
    programs = {
      vim.enable = true;
    };
  };
}
