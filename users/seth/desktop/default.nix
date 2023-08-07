{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
  inherit (lib) mkEnableOption mkIf;
in {
  imports = [
    ./budgie
    ./gnome
    ./plasma
    ../programs/mangohud.nix
    ../programs/firefox.nix
  ];

  options.desktop.enable = mkEnableOption "enable desktop configuration";

  config.home = mkIf cfg.enable {
    packages = with pkgs; [
      chromium
      discord
      element-desktop
      spotify
      steam
      prismlauncher
    ];
  };
}
