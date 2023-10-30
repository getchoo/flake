{
  config,
  lib,
  pkgs,
  ...
}: {
  options.desktop.enable = lib.mkEnableOption "desktop";

  imports = [
    ./budgie
    ./gnome
    ./plasma
  ];

  config = lib.mkIf config.desktop.enable {
    home.packages = with pkgs;
      [
        discord
        element-desktop
        spotify
        prismlauncher
      ]
      ++ lib.optionals stdenv.isDarwin [
        iterm2
      ]
      ++ lib.optionals stdenv.isLinux [
        steam
      ];
  };
}
