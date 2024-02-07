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
    # not sure why i have to force this
    environment.etc."nix/inputs/nixpkgs".source = lib.mkForce inputs.nixpkgs.outPath;

    services.nix-daemon.enable = true;
  };
}
