{config, ...}: {
  imports = [
    ./bash.nix
    ./fish.nix
  ];

  home = {
    sessionVariables = let
      inherit (config.xdg) configHome dataHome stateHome;
    in {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
      GPG_TTY = "$(tty)";
      CARGO_HOME = "${dataHome}/cargo";
      RUSTUP_HOME = "${dataHome}/rustup";
      LESSHISTFILE = "${stateHome}/less/history";
      NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
    };

    shellAliases = {
      diff = "diff --color=auto";
      g = "git";
      gs = "g status";
    };
  };
}
