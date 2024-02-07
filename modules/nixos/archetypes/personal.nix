{
  config,
  lib,
  ...
}: let
  cfg = config.archetypes.personal;
in {
  options.archetypes = {
    personal.enable = lib.mkEnableOption "personal archetype";
  };

  config = lib.mkIf cfg.enable {
    base.enable = true;

    traits = {
      home-manager.enable = true;

      locale = {
        en_US.enable = true;
        US-east.enable = true;
      };

      secrets.enable = true;
      tailscale.enable = true;
      user-setup.enable = true;

      users = {
        seth.enable = true;
      };
    };
  };
}
