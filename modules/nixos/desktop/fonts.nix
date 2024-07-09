{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.fonts;
in
{
  options.desktop.fonts = {
    enable = lib.mkEnableOption "desktop fonts" // {
      default = config.desktop.enable;
      defaultText = lib.literalExpression "config.desktop.enable";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;

      packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "Hack"
            "Noto"
          ];
        })
        noto-fonts
        noto-fonts-extra
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
      ];

      fontconfig = {
        enable = true;
        cache32Bit = lib.mkDefault true;
        defaultFonts = lib.mkDefault {
          serif = [ "Noto Serif" ];
          sansSerif = [ "Noto Sans" ];
          emoji = [ "Noto Color Emoji" ];
          monospace = [ "Noto Sans Mono" ];
        };
      };
    };
  };
}
