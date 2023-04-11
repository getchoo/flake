{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./shell
  ];

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
  home.stateVersion = "23.05";
}
