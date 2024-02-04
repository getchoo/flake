{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.seth.desktop;
in {
  options.seth.desktop = {
    enable = lib.mkEnableOption "desktop";
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
      prismlauncher
    ];
  };
}
