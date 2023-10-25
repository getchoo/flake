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
    ./firefox
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

    catppuccin.flavour = mkDefault "mocha";

    programs = {
      btop = {
        enable = mkDefault true;
        catppuccin.enable = mkDefault true;
      };

      direnv = {
        enable = mkDefault true;
        nix-direnv.enable = mkDefault true;
      };

      ripgrep.enable = mkDefault true;

      nix-index-database.comma.enable = mkDefault true;
    };

    xdg.enable = mkDefault true;
  };
}
