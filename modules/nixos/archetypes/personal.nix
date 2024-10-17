{ config, lib, ... }:
let
  cfg = config.archetypes.personal;
in
{
  options.archetypes = {
    personal.enable = lib.mkEnableOption "the Personal archetype";
  };

  config = lib.mkIf cfg.enable {
    base.enable = true;

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
