{
  config,
  lib,
  ...
}: let
  cfg = config.seth.shell;
in {
  options.seth.shell = {
    aliases.enable = lib.mkEnableOption "Shell aliases" // {default = true;};
    variables.enable = lib.mkEnableOption "Shell variables" // {default = true;};
  };

  imports = [
    ./bash.nix
    ./fish.nix
    ./nu.nix
    ./zsh.nix
  ];

  config = {
    home = lib.mkMerge [
      (lib.mkIf cfg.variables.enable {
        sessionVariables = rec {
          EDITOR = "nvim";
          VISUAL = EDITOR;
          CARGO_HOME = "${config.xdg.dataHome}/cargo";
          LESSHISTFILE = "${config.xdg.stateHome}/less/history";
        };
      })

      (lib.mkIf cfg.aliases.enable {
        shellAliases = {
          diff = "diff --color=auto";
          g = "git";
          gs = "g status";
        };
      })
    ];
  };
}
