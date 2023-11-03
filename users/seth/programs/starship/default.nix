{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    settings =
      {
        format = "$all";
        palette = "catppuccin_mocha";
        command_timeout = 250;
      }
      // fromTOML (builtins.readFile ./starship.toml);
  };
}
