{
  config,
  lib,
  pkgs,
  ...
}: let
  catppuccin =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "wezterm";
      rev = "b1a81bae74d66eaae16457f2d8f151b5bd4fe5da";
      hash = "sha256-McSWoZaJeK+oqdK/0vjiRxZGuLBpEB10Zg4+7p5dIGY=";
    }
    + "/dist/catppuccin-mocha.toml";
in {
  programs.wezterm = {
    enable = true;

    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;

    colorSchemes = {
      catppuccinMocha = lib.importTOML catppuccin;
    };

    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
