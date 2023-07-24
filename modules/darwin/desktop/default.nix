{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.desktop;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.desktop.enable = mkEnableOption "base nixos module";

  imports = [
    ./homebrew.nix
  ];

  config = mkIf cfg.enable {
    fonts.fonts = with pkgs;
      mkDefault [
        (nerdfonts.override {fonts = ["FiraCode"];})
      ];
  };
}
