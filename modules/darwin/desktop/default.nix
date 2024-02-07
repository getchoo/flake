{lib, ...}: {
  options.desktop = {
    enable = lib.mkEnableOption "base desktop settings";
  };

  imports = [
    ./fonts.nix
    ./homebrew.nix
    ./programs.nix
  ];
}
