{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.base.documentation;
  inherit (lib) mkEnableOption mkIf;
in {
  options.base.documentation.enable = mkEnableOption "base module documentation";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [man-pages man-pages-posix];
    documentation = {
      dev.enable = true;
      man.enable = true;
    };
  };
}
