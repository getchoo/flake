{
  config,
  lib,
  ...
}: let
  cfg = config.base.defaultPrograms;
  enable = config.base.enable && cfg.enable;
in {
  options.base.defaultPrograms = {
    enable = lib.mkEnableOption "default programs" // {default = true;};
  };

  config = lib.mkIf enable {
    programs.gnupg.agent.enable = lib.mkDefault true;
  };
}
