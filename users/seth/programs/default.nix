{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./bat.nix
    ./eza.nix
    ./git.nix
    ./gpg.nix
    ./ssh.nix
    ./starship
    ./vim.nix
  ];

  home.packages = with pkgs; [
    fd
    nix-your-shell
    nurl
    rclone
    restic
    inputs.getchvim.packages.${pkgs.stdenv.hostPlatform.system}.default
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

    ripgrep.enable = true;

    nix-index-database.comma.enable = true;
  };

  xdg.enable = true;
}
