{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop;
in
{
  options.desktop = {
    enable = lib.mkEnableOption "desktop settings";
  };

  imports = [
    ./audio.nix
    ./fonts.nix
    ./programs.nix

    ./budgie
    ./gnome
    ./niri
    ./plasma
  ];

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
  };
}
