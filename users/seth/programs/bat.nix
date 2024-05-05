{
  config,
  lib,
  ...
}: let
  cfg = config.seth.programs.bat;
in {
  options.seth.programs.bat = {
    enable = lib.mkEnableOption "bat configuration" // {default = config.seth.enable;};
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      catppuccin.enable = true;
    };
  };
}
