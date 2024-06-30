{ config, lib, ... }:
let
  cfg = config.seth.shell.bash;
in
{
  options.seth.shell.bash = {
    enable = lib.mkEnableOption "Bash configuration" // {
      default = config.seth.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;

      # TODO: find out if i need this anymore with standalone HM
      bashrcExtra = ''
        nixfile=${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh
        [ -e "$nixfile" ] && source "$nixfile"
      '';

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
  };
}
