{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.base.documentation;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.base.documentation.enable = mkEnableOption "base module documentation";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [man-pages man-pages-posix];
    documentation = {
      dev.enable = true;
      man = {
        enable = true;
        generateCaches = true;
        man-db.enable = false;
        mandoc.enable = true;
      };
    };
  };
}
