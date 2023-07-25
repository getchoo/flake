{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: {
  programs.gpg.enable = true;

  services.gpg-agent = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;

    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;

    pinentryFlavor =
      if osConfig ? programs
      then osConfig.programs.gnupg.agent.pinentryFlavor or "curses"
      else "curses";
  };
}
