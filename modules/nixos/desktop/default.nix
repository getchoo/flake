{
  config,
  lib,
  ...
}: let
  cfg = config.desktop;
in {
  options.desktop = {
    enable = lib.mkEnableOption "desktop settings";
  };

  imports = [
    ./audio.nix
    ./fonts.nix
    ./programs.nix

    ./budgie
    ./gnome
    ./plasma
    ./plasma5
  ];

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
  };
}
