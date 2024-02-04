{
  config,
  lib,
  ...
}: let
  cfg = config.suites.personal;
in {
  options.suites.personal = {
    enable = lib.mkEnableOption "Personal configuration set";
  };

  config = lib.mkIf cfg.enable {
    users.seth.enable = true;
  };
}
