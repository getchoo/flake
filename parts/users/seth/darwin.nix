{pkgs, ...}: {
  home.packages = with pkgs; [
    discord
    iterm2
    #prismlauncher
    #spotify
  ];
}
