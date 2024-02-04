{
  config,
  lib,
  ...
}: let
  cfg = config.suites.personal;
in {
  config = lib.mkIf cfg.enable {
    desktop.enable = true;
  };
}
