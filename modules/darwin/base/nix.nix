{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.base.nix-settings;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.base.nix-settings.enable = mkEnableOption "base nix settings";

  config = mkIf cfg.enable {
    nix = {
      gc.automatic = mkDefault true;

      settings = {
        experimental-features = ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];
        trusted-users = mkDefault ["root" "@wheel"];
      };
    };

    services.nix-daemon.enable = true;
  };
}
