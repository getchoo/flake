{pkgs, ...}: {
  imports = [./home.nix];

  home.packages = with pkgs; [
    discord
    iterm2
    spotify
  ];
}
