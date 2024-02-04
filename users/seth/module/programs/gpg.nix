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
    enable = lib.mkEnableOption "GnuPG configuration" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.gpg.enable = true;

    services.gpg-agent = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;

      pinentryFlavor =
        if osConfig ? programs
        then osConfig.programs.gnupg.agent.pinentryFlavor or "curses"
        else "curses";
    };
  };
}
