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
      config = {
        theme = "catppuccin";
      };
      themes = {
        catppuccin = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          }
          + "/Catppuccin-mocha.tmTheme");
      };
    };
    exa = {
      enable = true;
      enableAliases = true;
      icons = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };
  };

  xdg.configFile."starship.toml".source = ./starship.toml;

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
      GPG_TTY = "$(tty)";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      LESSHISTFILE = "${config.xdg.stateHome}/less/history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    };

    shellAliases = {
      diff = "diff --color=auto";
      g = "git";
      gs = "g status";
      nixsw = "sudo nixos-rebuild switch";
      nixup = "nixsw --upgrade";
    };
  };
}
