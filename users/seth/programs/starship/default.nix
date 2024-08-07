{ config, lib, ... }:
let
  cfg = config.seth.programs.starship;
in
{
  options.seth.programs.starship = {
    enable = lib.mkEnableOption "Starship configuration" // {
      default = config.seth.enable;
      defaultText = lib.literalExpression "config.seth.enable";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      # i do this manually
      catppuccin.enable = false;

      enableBashIntegration = false;
      enableZshIntegration = false;

      settings = {
        format = "$all";
        palette = "catppuccin_mocha";
        command_timeout = 250;
      } // lib.importTOML ./starship.toml;
    };
  };
}
