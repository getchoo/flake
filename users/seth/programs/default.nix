{
  config,
  pkgs,
  ...
}: let
  develPackages =
    if config.seth.devel.enable
    then
      with pkgs; [
        alejandra
        clang
        deadnix
        eclint
        statix
      ]
    else [];
in {
  imports = [
    ./git.nix
    # ./mangohud
    ./neovim
    ./starship.nix
    ./vim.nix
    ./xdg.nix
  ];

  home.packages = with pkgs;
    [
      bat
      exa
      fd
      gh
      lld
      ripgrep
      python311
    ]
    ++ develPackages;
}
