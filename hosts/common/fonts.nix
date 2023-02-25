{
  pkgs,
  desktop,
  ...
}: let
  gui = desktop != "";
in {
  fonts = {
    enableDefaultFonts = gui;
    fonts =
      if gui
      then
        with pkgs; [
          corefonts
          fira-code
          (nerdfonts.override {fonts = ["FiraCode"];})
          noto-fonts
          noto-fonts-extra
          noto-fonts-emoji
          noto-fonts-cjk-sans
        ]
      else [];
    fontconfig.defaultFonts =
      if gui
      then {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
        emoji = ["Noto Color Emoji"];
        monospace = ["Fira Code"];
      }
      else {};
  };
}
