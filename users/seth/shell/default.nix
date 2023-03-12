{config, ...}: {
  imports = [
    ./bash.nix
    ./fish.nix
  ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile."starship.toml".source = ./starship.toml;

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
      GPG_TTY = "$(tty)";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      LESSHISTFILE = "${config.xdg.stateHome}/less/history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    };

    shellAliases = {
      ls = "exa --icons";
      la = "ls -a";
      diff = "diff --color=auto";
      g = "git";
      gs = "g status";
      nixsw = "sudo nixos-rebuild switch";
      nixup = "nixsw --upgrade";
    };
  };
}
