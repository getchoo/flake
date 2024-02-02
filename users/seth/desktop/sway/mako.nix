{pkgs, ...}: {
  home.packages = [pkgs.libnotify];

  services.mako = {
    enable = true;
    catppuccin.enable = true;

    font = "Noto Sans Regular 11";
    borderRadius = 10;
    borderSize = 3;
  };
}
