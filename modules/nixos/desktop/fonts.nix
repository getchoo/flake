{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.getchoo.desktop.fonts;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.desktop.fonts.enable = mkEnableOption "enable default fonts";

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultFonts = true;

      fonts = with pkgs; [
        corefonts
        fira-code
        (nerdfonts.override {fonts = ["FiraCode"];})
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        noto-fonts-cjk-sans
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = ["Noto Serif"];
          sansSerif = ["Noto Sans"];
          emoji = ["Noto Color Emoji"];
          monospace = ["Fira Code"];
        };
      };
    };
  };
}
