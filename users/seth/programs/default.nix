{pkgs, ...}: {
  imports = [
    ./git.nix
    ./neovim.nix
    ./starship.nix
    ./vim.nix
  ];

  home.packages = with pkgs; [
    alejandra
    bat
    clang
    deadnix
    eclint
    exa
    fd
    gh
    lld
    rclone
    restic
    ripgrep
    statix
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
  };

  xdg.enable = true;
}
