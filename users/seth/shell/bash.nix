{config, ...}: {
  programs.bash = {
    enable = true;
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
}
