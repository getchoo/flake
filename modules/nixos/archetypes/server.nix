{
  config,
  lib,
  ...
}: let
  cfg = config.archetypes.server;
in {
  options.archetypes = {
    server.enable = lib.mkEnableOption "server archetype";
  };

  config = lib.mkIf cfg.enable {
    base = {
      enable = true;
      documentation.enable = false;
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

      locale = {
        en_US.enable = true;
        US-east.enable = true;
      };

      secrets.enable = true;

      tailscale = {
        enable = true;
        ssh.enable = true;
      };

      user-setup.enable = true;
      users = {
        hostUser.enable = true;
      };

      zram.enable = true;
    };
  };
}
