{
  config,
  lib,
  ...
}: let
  cfg = config.traits.users.seth;
in {
  imports = [./system.nix];

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.seth = {
        seth.desktop.enable = false;
      };
    })
  ];
}
