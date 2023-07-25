{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.base.defaultPackages;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.base.defaultPackages.enable = mkEnableOption "base module default packages";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      python311
    ];

    programs = {
      git.enable = true;
      gnupg.agent.enable = true;
      vim.defaultEditor = true;
    };
  };
}
