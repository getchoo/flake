{pkgs, ...}: {
  home.packages = [pkgs.catppuccin-kvantum];

  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };
}
