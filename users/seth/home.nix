{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./shell
  ];

  home = {
    username = "seth";
    homeDirectory = "/home/seth";
    stateVersion = "23.05";
  };

  nix.package = lib.mkDefault pkgs.nixFlakes;
}
