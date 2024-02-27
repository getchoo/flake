{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.seth.desktop;
in {
  options.seth.desktop = {
    enable =
      lib.mkEnableOption "desktop"
      // {
        default = osConfig.desktop.enable or false;
      };
  };

  imports = [
    ./budgie
    ./gnome
    ./plasma
  ];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      element-desktop
      spotify
      (prismlauncher.override {withWaylandGLFW = true;})
    ];
  };
}
