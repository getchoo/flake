{
  imports = [../shared];

  programs = {
    bash.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };

  services.nix-daemon.enable = true;
}
