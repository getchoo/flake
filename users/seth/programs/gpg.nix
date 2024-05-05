{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.seth.programs.gpg;
in {
  options.seth.programs.gpg = {
    enable = lib.mkEnableOption "GnuPG configuration" // {default = config.seth.enable;};
  };

  config = lib.mkIf cfg.enable {
    programs.gpg.enable = true;

    services.gpg-agent = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      pinentryPackage = osConfig.programs.gnupg.agent.pinentryPackage or pkgs.pinentry-curses;
    };
  };
}
