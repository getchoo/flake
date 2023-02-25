{pkgs, ...}: {
  imports = [
    ./git.nix
    ./neovim.nix
    ./starship.nix
    ./vim.nix
  ];

  home.packages = with pkgs; [
    bat
    llvmPackages_15.stdenv
    exa
    fd
    gh
    lld
    rclone
    restic
    ripgrep
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
