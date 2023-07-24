{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.base.documentation;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.base.documentation.enable = mkEnableOption "base module documentation";

  config = mkIf cfg.enable {
    documentation.man.enable = true;
  };
}
