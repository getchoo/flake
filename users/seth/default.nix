{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.seth;
in
{
  options.seth = {
    enable = lib.mkEnableOption "Seth's home configuration";

    shellAliases.enable = lib.mkEnableOption "shell aliases" // {
      default = config.seth.enable;
      defaultText = lib.literalExpression "config.seth.enable";
    };

    shellVariables.enable = lib.mkEnableOption "shell variables" // {
      default = config.seth.enable;
      defaultText = lib.literalExpression "config.seth.enable";
    };

    standalone.enable = lib.mkEnableOption "standalone configuration mode";
  };

  imports = [
    ./desktop
    ./programs
    ./services
    ./tweaks
  ];

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      { home.stateVersion = "23.11"; }

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

      (lib.mkIf cfg.standalone.enable {
        # This won't be set in standalone configurations
        _module.args.osConfig = { };

        # Make sure we can switch & update
        programs.home-manager.enable = true;

        home = {
          username = "seth";
          homeDirectory = (if pkgs.stdenv.isDarwin then "/Users" else "/home") + "/${config.home.username}";
        };
      })
    ]
  );
}
