{
  config,
  lib,
  ...
}: let
  cfg = config.suites.server;
in {
  options.suites.server = {
    enable = lib.mkEnableOption "Server configuration set";
  };

  config = lib.mkIf cfg.enable {
    features.tailscale = {
      enable = true;
      ssh.enable = true;
    };

    server = {
      enable = true;
      secrets.enable = true;
    };
  };
}
