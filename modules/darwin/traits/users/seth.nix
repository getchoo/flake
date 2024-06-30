{ config, lib, ... }:
let
  cfg = config.traits.users.seth;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.seth = {
        seth.desktop.enable = false;
      };
    })
  ];
}
