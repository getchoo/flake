{ lib, ... }:
{
  options.desktop = {
    enable = lib.mkEnableOption "basic desktop settings";
  };

  imports = [
    ./fonts.nix
    ./homebrew.nix
    ./programs.nix
  ];
}
