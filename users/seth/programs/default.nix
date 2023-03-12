{pkgs, ...}: {
  imports = [
    ./git.nix
    ./neovim
    ./vim.nix
  ];

  home.packages = with pkgs; [
    btop
    llvmPackages_15.clang
    fd
    gh
    lld
    nix-your-shell
    rclone
    restic
    ripgrep
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
    configFile."btop/themes/catppuccin_mocha.theme" = {
      text = ''
        theme[main_bg]="#1E1E2E"
        theme[main_fg]="#CDD6F4"
        theme[title]="#CDD6F4"
        theme[hi_fg]="#89B4FA"
        theme[selected_bg]="#45475A"
        theme[selected_fg]="#89B4FA"
        theme[inactive_fg]="#7F849C"
        theme[graph_text]="#F5E0DC"
        theme[meter_bg]="#45475A"
        theme[proc_misc]="#F5E0DC"
        theme[cpu_box]="#74C7EC"
        theme[mem_box]="#A6E3A1"
        theme[net_box]="#CBA6F7"
        theme[proc_box]="#F2CDCD"
        theme[div_line]="#6C7086"
        theme[temp_start]="#F9E2AF"
        theme[temp_mid]="#FAB387"
        theme[temp_end]="#F38BA8"
        theme[cpu_start]="#74C7EC"
        theme[cpu_mid]="#89DCEB"
        theme[cpu_end]="#94E2D5"
        theme[free_start]="#94E2D5"
        theme[free_mid]="#94E2D5"
        theme[free_end]="#A6E3A1"
        theme[cached_start]="#F5C2E7"
        theme[cached_mid]="#F5C2E7"
        theme[cached_end]="#CBA6F7"
        theme[available_start]="#F5E0DC"
        theme[available_mid]="#F2CDCD"
        theme[available_end]="#F2CDCD"
        theme[used_start]="#FAB387"
        theme[used_mid]="#FAB387"
        theme[used_end]="#F38BA8"
        theme[download_start]="#B4BEFE"
        theme[download_mid]="#B4BEFE"
        theme[download_end]="#CBA6F7"
        theme[upload_start]="#B4BEFE"
        theme[upload_mid]="#B4BEFE"
        theme[upload_end]="#CBA6F7"
        theme[process_start]="#74C7EC"
        theme[process_mid]="#89DCEB"
        theme[process_end]="#94E2D5"
      '';
    };
  };
}
