{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.programs.defaultPrograms;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.programs.defaultPrograms.enable = mkEnableOption "default programs" // {default = true;};

  imports = [
    ./chromium.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    ./mangohud.nix
    ./neovim
    ./ssh.nix
    ./vim.nix
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fd
      nix-your-shell
      nurl
      rclone
      restic
    ];

    programs = {
      btop.enable = mkDefault true;

      direnv = {
        enable = mkDefault true;
        nix-direnv.enable = mkDefault true;
      };

      ripgrep.enable = mkDefault true;

      nix-index-database.comma.enable = mkDefault true;
    };

    xdg =
      {
        enable = mkDefault true;
      }
      // (mkIf config.programs.btop.enable {
        configFile."btop/themes/catppuccin_mocha.theme".source =
          pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "btop";
            rev = "ecb8562bb6181bb9f2285c360bbafeb383249ec3";
            sha256 = "sha256-ovVtupO5jWUw6cwA3xEzRe1juUB8ykfarMRVTglx3mk=";
          }
          + "/catppuccin_mocha.theme";
      });
  };
}
