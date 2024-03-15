{
  config,
  lib,
  ...
}: let
  cfg = config.seth.programs.eza;
in {
  options.seth.programs.eza = {
    enable = lib.mkEnableOption "eza configuration" // {default = config.seth.enable;};
  };

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      icons = true;
    };
  };
}
