{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (builtins) attrNames map;
  inherit (lib) mkIf;
  cfg = config.base.nix-settings;

  channelPath = i: "${inputs.${i}.outPath}";

  mapInputs = fn: map fn (attrNames inputs);
in {
  config = mkIf cfg.enable {
    nix.nixPath = mapInputs (i: "${i}=${channelPath i}");
  };
}
