{ config, lib, ... }:
let
  cfg = config.profiles.personal;
in
{
  options.profiles.personal = {
    enable = lib.mkEnableOption "the Personal profile";
  };

  config = lib.mkIf cfg.enable {
    traits = {
      home-manager.enable = true;

      secrets.enable = true;
      tailscale.enable = true;

      users = {
        seth.enable = true;
      };
    };
  };
}
