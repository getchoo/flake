{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./shell
  ];

  nix = {
    package = lib.mkDefault pkgs.nixFlakes;
    settings.warn-dirty = false;
  };
  xdg = {
    enable = true;
    configFile."nixpkgs/config.nix".text = ''
      {
       	allowUnfree = true;
        allowUnsupportedSystem;
      }
    '';
  };
  home.stateVersion = "23.05";
}
