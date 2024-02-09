{
  config,
  lib,
  ...
}: let
  cfg = config.seth.programs.starship;
in {
  options.seth.programs.starship = {
    enable = lib.mkEnableOption "Starship configuration" // {default = config.seth.enable;};
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      enableBashIntegration = false;
      enableZshIntegration = false;

      settings =
        {
          format = "$all";
          palette = "catppuccin_mocha";
          command_timeout = 250;
        }
        // fromTOML (builtins.readFile ./starship.toml);
    };
  };
}
