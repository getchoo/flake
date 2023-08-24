{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.base.defaultPackages;
  inherit (lib) mkEnableOption mkIf;
in {
  options.base.defaultPackages.enable = mkEnableOption "base module default packages";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      python311
    ];

    programs = {
      gnupg.agent.enable = true;
    };
  };
}
