{
  pkgs,
  desktop,
  ...
}:
if desktop != ""
then {
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
    fontconfig.defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      emoji = ["Noto Color Emoji"];
      monospace = ["Fira Code"];
    };
  };
}
else {}
