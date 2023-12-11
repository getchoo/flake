{
  pkgs,
  inputs',
  ...
}: {
  imports = [
    ./bat.nix
    ./eza.nix
    ./git.nix
    ./gpg.nix
    ./ssh.nix
    ./starship
    ./vim.nix
  ];

  home.packages = with pkgs; [
    fd
    nurl
    rclone
    restic

    inputs'.attic.packages.attic

    (let
      getchvim = inputs'.getchvim.packages.default;
    in
      # remove desktop file
      symlinkJoin {
        name = builtins.replaceStrings ["neovim"] ["neovim-nodesktop"] getchvim.name;
        paths = [getchvim];
        postBuild = ''
          rm -rf $out/share/{applications,icons}
        '';
      })
  ];

  catppuccin.flavour = "mocha";

  programs = {
    btop = {
      enable = true;
      catppuccin.enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    glamour.catppuccin.enable = true;

    ripgrep.enable = true;

    nix-index-database.comma.enable = true;
  };

  xdg.enable = true;
}
