{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.seth.programs;
in
{
  options.seth.programs = {
    basePrograms.enable = lib.mkEnableOption "base programs and configurations" // {
      default = config.seth.enable;
    };
  };

  imports = with inputs; [
    catppuccin.homeManagerModules.catppuccin
    nix-index-database.hmModules.nix-index

    ./bash.nix
    ./chromium.nix
    ./firefox
    ./fish.nix
    ./git.nix
    ./gpg.nix
    ./mangohud.nix
    ./moar.nix
    ./ncspot.nix
    ./neovim.nix
    ./nu.nix
    ./ssh.nix
    ./starship
    ./vim.nix
    ./vscode.nix
    ./yazi.nix
    ./zellij.nix
    ./zsh.nix
  ];

  config = lib.mkIf cfg.basePrograms.enable {
    home.packages = with pkgs; [
      fd
      nix-output-monitor
      nurl
      rclone
      restic
    ];

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };

    programs = {
      bat.enable = true;
      btop.enable = true;

      eza = {
        enable = true;
        icons = "auto";
      };

      direnv = {
        enable = true;
        nix-direnv = {
          enable = true;
          package = pkgs.nix-direnv.override { nix = pkgs.lix; };
        };
      };

      ripgrep.enable = true;

      nix-index-database.comma.enable = true;
    };

    xdg.enable = true;
  };
}
