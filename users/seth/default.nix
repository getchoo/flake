{inputs, ...}: {
  imports = with inputs; [
    ./programs
    ./shell

    arkenfox.hmModules.arkenfox
    catppuccin.homeManagerModules.catppuccin
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "23.11";
}
