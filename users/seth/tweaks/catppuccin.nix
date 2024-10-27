{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.seth.tweaks.catppuccin;
in
{
  options.seth.tweaks.catppuccin = {
    enable = lib.mkEnableOption "catppuccin themeing" // {
      default = config.seth.enable;
      defaultText = "config.seth.enable";
    };
  };

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = true;
      accent = "mauve";
      flavor = "mocha";
    };
  };
}
