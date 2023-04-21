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

  xdg = {
    enable = true;
    configFile."nixpkgs/config.nix".text = ''
      {
       	allowUnfree = true;
        allowUnsupportedSystem = true;
      }
    '';
  };
}
