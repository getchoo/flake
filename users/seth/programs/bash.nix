{ config, lib, ... }:
let
  cfg = config.seth.programs.bash;
in
{
  options.seth.programs.bash = {
    enable = lib.mkEnableOption "Bash configuration" // {
      default = config.seth.enable;
      defaultText = lib.literalExpression "config.seth.enable";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.bash = {
          enable = true;

          historyFile = "${config.xdg.stateHome}/bash/history";
          historyFileSize = 1000;
          historySize = 100;

          shellOptions = [
            "cdspell"
            "checkjobs"
            "checkwinsize"
            "dirspell"
            "globstar"
            "histappend"
            "no_empty_cmd_completion"
          ];
        };
      }

      # TODO: find out if i need this anymore with standalone HM
      (lib.mkIf config.seth.standalone.enable {
        programs.bash = {

          bashrcExtra = ''
            nixfile=${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh
            [ -e "$nixfile" ] && source "$nixfile"
          '';
        };
      })
    ]
  );
}
