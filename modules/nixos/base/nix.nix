{
  config,
  lib,
  ...
}: let
  cfg = config.base.nixSettings;
  enable = config.base.enable && cfg.enable;
in {
  config = lib.mkIf enable {
    nix = {
      channel.enable = lib.mkDefault false;
      gc.dates = lib.mkDefault "weekly";
      settings.trusted-users = ["root" "@wheel"];
    };
  };
}
