{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.base.nixSettings;
  enable = config.base.enable && cfg.enable;
in {
  config = lib.mkIf enable {
    # not sure why i can't use this on darwin?
    environment.etc."nix/inputs/nixpkgs".source = lib.mkDefault inputs.nixpkgs.outPath;

    nix = {
      channel.enable = lib.mkDefault false;
      gc.dates = lib.mkDefault "weekly";
      settings.trusted-users = ["root" "@wheel"];
    };
  };
}
