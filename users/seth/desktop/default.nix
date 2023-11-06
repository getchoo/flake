{
  config,
  lib,
  pkgs,
  ...
}: {
  options.desktop.enable = lib.mkEnableOption "desktop";

  imports = [
    ./budgie
    ./gnome
    ./plasma
    ./sway
  ];

  config = lib.mkIf config.desktop.enable {
    home.packages = with pkgs; [
      discord
      element-desktop
      spotify
      prismlauncher
    ];
  };
}
