{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.seth.standalone;
  enable = config.seth.enable && cfg.enable;
in {
  options.seth.standalone = {
    enable = lib.mkEnableOption "Standalone options";
  };

  config = lib.mkIf enable {
    _module.args.osConfig = {};
    programs.home-manager.enable = true;

    home = {
      username = "seth";
      homeDirectory =
        if pkgs.stdenv.isDarwin
        then "/Users/${config.home.username}"
        else "/home/${config.home.username}";
    };
  };
}
