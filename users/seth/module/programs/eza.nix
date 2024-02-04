{
  config,
  lib,
  ...
}: let
  cfg = config.seth.programs.eza;
in {
  options.seth.programs.eza = {
    enable = lib.mkEnableOption "eza configuration" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableAliases = true;
      icons = true;
    };
  };
}
