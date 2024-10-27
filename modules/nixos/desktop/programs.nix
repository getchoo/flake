{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    environment.systemPackages = [
      pkgs.wl-clipboard
    ];

    programs = {
      chromium.enable = lib.mkDefault true;
      firefox.enable = lib.mkDefault true;
    };

    xdg.portal.enable = lib.mkDefault true;
  };
}
