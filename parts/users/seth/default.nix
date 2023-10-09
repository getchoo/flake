{inputs, ...}: {
  imports = with inputs; [
    ./desktop
    ./programs
    ./shell
    arkenfox.hmModules.arkenfox
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "23.11";
}