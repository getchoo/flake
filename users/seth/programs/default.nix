{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.seth.programs;
in {
  options.seth.programs = {
    basePrograms.enable =
      lib.mkEnableOption "base programs and configurations"
      // {
        default = config.seth.enable;
      };
  };

  imports = with inputs; [
    catppuccin.homeManagerModules.catppuccin
    nix-index-database.hmModules.nix-index
    ./bat.nix
    ./chromium.nix
    ./eza.nix
    ./firefox
    ./git.nix
    ./gpg.nix
    ./mangohud.nix
    ./neovim.nix
    ./ssh.nix
    ./starship
    ./vim.nix
    ./vscode.nix
  ];

  config = lib.mkIf cfg.basePrograms.enable {
    home.packages = with pkgs; [
      fd
      nix-output-monitor
      nurl
      rclone
      restic
    ];

    catppuccin.flavour = "mocha";

    programs = {
      btop = {
        enable = true;
        catppuccin.enable = true;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      glamour.catppuccin.enable = true;

      ripgrep.enable = true;

      nix-index-database.comma.enable = true;
    };

    xdg.enable = true;
  };
}
