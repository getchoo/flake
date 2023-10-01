{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.getchoo.desktop;
  desktops = ["budgie" "gnome" "plasma"];
  inherit (lib) mkEnableOption mkIf;
in {
  imports = [
    ./budgie
    ./gnome
    ./plasma
  ];

  options.getchoo.desktop =
    {
      enable = mkEnableOption "desktop configuration" // {default = osConfig.desktop.enable or false;};
    }
    // lib.genAttrs desktops (desktop: {
      enable =
        mkEnableOption desktop
        // {default = osConfig.desktop.${desktop}.enable or false;};
    });

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      element-desktop
      spotify
      steam
      prismlauncher
    ];

    getchoo.programs = {
      chromium.enable = true;
      firefox.enable = true;
      mangohud.enable = true;
    };
  };
}
