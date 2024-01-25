{config, ...}: {
  imports = [
    ./bash.nix
    ./fish.nix
  ];

  home = {
    sessionVariables = rec {
      EDITOR = "nvim";
      VISUAL = EDITOR;
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      LESSHISTFILE = "${config.xdg.stateHome}/less/history";
    };

    shellAliases = {
      diff = "diff --color=auto";
      g = "git";
      gs = "g status";
    };
  };
}
