{ config, lib, ... }:
let
  cfg = config.archetypes.server;
in
{
  options.archetypes = {
    server.enable = lib.mkEnableOption "the Server archetype";
  };

  config = lib.mkIf cfg.enable {
    base = {
      enable = true;
      defaultPrograms.enable = false;
    };

    server = {
      enable = true;
      mixins = {
        cloudflared.enable = true;
        nginx.enable = true;
      };
    };

    traits = {
      autoUpgrade.enable = true;

      secrets.enable = true;

      tailscale = {
        enable = true;
        ssh.enable = true;
      };

      zram.enable = true;
    };
  };
}
