{
  config,
  lib,
  ...
}: let
  cfg = config.base.documentation;
  enable = config.base.enable && cfg.enable;
in {
  options.base.documentation = {
    enable = lib.mkEnableOption "documentation settings" // {default = true;};
  };

  config = lib.mkIf enable {
    documentation = {
      doc.enable = false;
      info.enable = false;
    };
  };
}
