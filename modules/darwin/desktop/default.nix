{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.desktop;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.desktop = {
    enable = mkEnableOption "enable desktop darwin support";
    gpg.enable = mkEnableOption "enable gpg";
  };

  imports = [
    ./homebrew.nix
  ];

  config = mkIf cfg.enable {
    fonts.fonts = with pkgs;
      mkDefault [
        (nerdfonts.override {fonts = ["FiraCode"];})
      ];

    programs.gnupg.agent.enable = cfg.gpg.enable;
  };
}
