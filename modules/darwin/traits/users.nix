{
  config,
  lib,
  ...
}: let
  cfg = config.traits.users;
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.seth.enable {
      home-manager.users.seth = {
        seth.desktop.enable = false;
      };
    })
  ];
}
