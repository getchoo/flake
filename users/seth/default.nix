{ config, lib, ... }:
let
  cfg = config.seth;
in
{
  options.seth = {
    shellAliases.enable = lib.mkEnableOption "shell aliases" // {
      default = config.seth.enable;
      defaultText = lib.literalExpression "config.seth.enable";
    };

    shellVariables.enable = lib.mkEnableOption "shell variables" // {
      default = config.seth.enable;
      defaultText = lib.literalExpression "config.seth.enable";
    };
  };

  imports = [
    ./base
    ./desktop
    ./programs
    ./services
    ./tweaks
  ];

  config = lib.mkMerge [
    (lib.mkIf cfg.shellAliases.enable {
      home.shellAliases = {
        diff = "diff --color=auto";
        g = "git";
        gs = "g status";
      };
    })

    (lib.mkIf cfg.shellVariables.enable {
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = config.home.sessionVariables.EDITOR;
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        LESSHISTFILE = "${config.xdg.stateHome}/less/history";
      };
    })
  ];
}
