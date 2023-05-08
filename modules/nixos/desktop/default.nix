{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.desktop;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./audio.nix
    ./budgie
    ./fonts.nix
    ./gnome
    ./plasma
  ];

  options.getchoo.desktop.enable = mkEnableOption "desktop module";

  config = mkIf cfg.enable {
    getchoo = {
      base.enable = true;
      desktop = {
        audio.enable = mkDefault true;
        fonts.enable = mkDefault true;
      };
    };

    environment = {
      noXlibs = lib.mkForce false;
      systemPackages = with pkgs; [pinentry-curses wl-clipboard xclip];
    };

    programs = {
      dconf.enable = true;
      firefox.enable = true;
      xwayland.enable = true;
    };

    services.xserver.enable = true;
    xdg.portal.enable = true;
  };
}
