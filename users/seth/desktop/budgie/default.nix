{
  lib,
  osConfig,
  ...
}: let
  enable = osConfig.services.xserver.desktopManager.budgie.enable or false;
in {
  config = lib.mkIf enable {
    programs.alacritty = {
      enable = true;
      catppuccin.enable = true;
    };

    dconf = {
      enable = true;
      settings = {
        "com.solus-project.budgie-panel:Budgie" = {
          pinned-launchers = ["firefox.desktop" "nemo.desktop" "discord.desktop"];
        };
      };
    };
  };
}
