{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.fonts;
  enable = config.desktop.enable && cfg.enable;
in {
  options.desktop.fonts = {
    enable = lib.mkEnableOption "desktop fonts" // {default = true;};
  };

  config = lib.mkIf enable {
    fonts = {
      enableDefaultPackages = true;

      packages = with pkgs; [
        (nerdfonts.override {fonts = ["FiraCode" "Hack" "Noto"];})
        noto-fonts
        noto-fonts-extra
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
      ];

      fontconfig = {
        enable = true;
        cache32Bit = lib.mkDefault true;
        defaultFonts = lib.mkDefault {
          serif = ["Noto Serif"];
          sansSerif = ["Noto Sans"];
          emoji = ["Noto Color Emoji"];
          monospace = ["Noto Sans Mono"];
        };
      };
    };
  };
}
