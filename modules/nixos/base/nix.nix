{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.base.nix-settings;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.base.nix-settings.enable = mkEnableOption "base nix settings";

  imports = [
    ./documentation.nix
    ./packages.nix
  ];

  config = let
    channelPath = i: "/etc/nix/channels/${i}";
    mapInputs = fn: builtins.map fn (builtins.attrNames inputs);
  in
    mkIf cfg.enable {
      nix = {
        gc = {
          automatic = mkDefault true;
          dates = mkDefault "weekly";
          options = mkDefault "--delete-older-than 7d";
        };

        settings = {
          auto-optimise-store = true;
          experimental-features = ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];
        };

        nixPath = mapInputs (i: "${i}=${channelPath i}");
      };

      systemd.tmpfiles.rules =
        mapInputs (i: "L+ ${channelPath i}     - - - - ${inputs.${i}.outPath}");
    };
}
