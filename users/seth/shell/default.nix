{
  config,
  pkgs,
  ...
}: let
  inherit (builtins) fromTOML readFile;
  inherit (pkgs) fetchFromGitHub;
in {
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
        catppuccin = readFile (fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          }
          + "/Catppuccin-mocha.tmTheme");
      };
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
          command_timeout = 50;
        }
        // fromTOML (readFile ./starship.toml)
        // fromTOML (readFile
          (fetchFromGitHub
            {
              owner = "catppuccin";
              repo = "starship";
              rev = "3e3e54410c3189053f4da7a7043261361a1ed1bc";
              sha256 = "sha256-soEBVlq3ULeiZFAdQYMRFuswIIhI9bclIU8WXjxd7oY=";
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
