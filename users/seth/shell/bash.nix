{
  config,
  standalone,
  ...
}: {
  programs.bash = {
    enable = true;
    bashrcExtra =
      if standalone
      then ''
        . ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh
      ''
      else '''';
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
