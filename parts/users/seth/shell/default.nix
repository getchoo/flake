{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bash.nix
    ./fish.nix
  ];

  programs = {
    bat = {
      enable = true;
      catppuccin.enable = true;
    };

    eza = {
      enable = true;
      enableAliases = true;
      icons = true;
    };

    starship = {
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
  };

  home = {
    sessionVariables = let
      inherit (config.xdg) configHome dataHome stateHome;
    in {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
      GPG_TTY = "$(tty)";
      CARGO_HOME = "${dataHome}/cargo";
      RUSTUP_HOME = "${dataHome}/rustup";
      LESSHISTFILE = "${stateHome}/less/history";
      NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
    };

    shellAliases = {
      diff = "diff --color=auto";
      g = "git";
      gs = "g status";
    };
  };
}
