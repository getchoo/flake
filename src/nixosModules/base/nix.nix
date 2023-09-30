{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (builtins) attrNames map;
  inherit (lib) mkDefault mkIf;
  cfg = config.base.nix-settings;

  channelPath = i: "/etc/nix/channels/${i}";

  mapInputs = fn: map fn (attrNames inputs);
in {
  config = mkIf cfg.enable {
    nix = {
      nixPath = mapInputs (i: "${i}=${channelPath i}");
      gc.dates = mkDefault "weekly";
    };

    systemd.tmpfiles.rules =
      mapInputs (i: "L+ ${channelPath i}     - - - - ${inputs.${i}.outPath}");
  };
}
