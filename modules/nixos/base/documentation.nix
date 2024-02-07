{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.base.documentation;
  enable = config.base.enable && cfg.enable;
in {
  config = lib.mkIf enable {
    documentation.nixos.enable = false;

    environment.systemPackages = with pkgs; [man-pages man-pages-posix];
  };
}
