{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.base.documentation;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [man-pages man-pages-posix];
    documentation = {
      man = {
        generateCaches = true;
        man-db.enable = true;
      };

      dev.enable = true;
    };
  };
}
