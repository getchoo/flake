{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: {
  programs = {
    gpg.enable = true;

    git = {
      enable = true;

      extraConfig = {
        init = {defaultBranch = "main";};
      };

      signing = {
        key = "D31BD0D494BBEE86";
        signByDefault = true;
      };

      userEmail = "getchoo@tuta.io";
      userName = "seth";
    };

    ssh = {
      enable = true;
      package = pkgs.openssh;
    };
  };

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
