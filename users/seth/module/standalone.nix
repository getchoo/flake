{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.seth.standalone;
in {
  options.seth.standalone = {
    enable = lib.mkEnableOption "Standalone options";
  };

  config = lib.mkIf cfg.enable {
    home = {
      username = "seth";
      homeDirectory =
        if pkgs.stdenv.isDarwin
        then "/Users/${config.home.username}"
        else "/home/${config.home.username}";
    };

    nixpkgs.overlays = [inputs.self.overlays.default];
  };
}
