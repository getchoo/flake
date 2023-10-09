{
  config,
  lib,
  ...
}: let
  cfg = config.base.documentation;
  inherit (lib) mkEnableOption mkIf;
in {
  options.base.documentation.enable = mkEnableOption "base module documentation";

  config = mkIf cfg.enable {
    documentation.man.enable = true;
  };
}