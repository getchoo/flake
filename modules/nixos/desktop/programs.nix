{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.defaultPrograms;
in
{
  options.desktop.defaultPrograms = {
    enable = lib.mkEnableOption "default desktop programs" // {
      default = config.desktop.enable;
      defaultText = lib.literalExpression "config.desktop.enable";
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      noXlibs = lib.mkForce false;
      systemPackages = with pkgs; [
        wl-clipboard
        xclip
      ];
    };

    programs = {
      chromium.enable = true;
      firefox.enable = true;
      xwayland.enable = true;
    };

    xdg.portal.enable = true;
  };
}
