{pkgs, ...}: {
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
      // fromTOML (builtins.readFile ./starship.toml)
      // fromTOML (builtins.readFile
        (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "starship";
            rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
            hash = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
          }
          + "/palettes/mocha.toml"));
  };
}
