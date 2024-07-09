{ config, lib, ... }:
let
  cfg = config.base.nixSettings;
in
{
  config = lib.mkIf cfg.enable {
    nix = {
      channel.enable = lib.mkDefault false;
      settings.trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
