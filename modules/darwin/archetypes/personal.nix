{
  config,
  lib,
  ...
}: let
  cfg = config.archetypes.personal;
in {
  options.archetypes.personal = {
    enable = lib.mkEnableOption "personal archetype";
  };

  config = lib.mkIf cfg.enable {
    base.enable = true;
    desktop.enable = true;

    traits = {
      home-manager.enable = true;
      users.seth.enable = true;
    };
  };
}
