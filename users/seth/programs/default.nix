{pkgs, ...}: {
  imports = [
    ./git.nix
    ./neovim
    ./vim.nix
  ];

  home.packages = with pkgs; [
    btop
    cargo
    llvmPackages_15.clang
    fd
    gh
    lld
    nix-your-shell
    nurl
    rclone
    restic
    ripgrep
    rustc
    rustfmt
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
  };

  xdg = {
    enable = true;
    configFile."btop/themes/catppuccin_mocha.theme".source =
      pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "btop";
        rev = "ecb8562bb6181bb9f2285c360bbafeb383249ec3";
        sha256 = "sha256-ovVtupO5jWUw6cwA3xEzRe1juUB8ykfarMRVTglx3mk=";
      }
      + "/catppuccin_mocha.theme";
  };
}
