{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      alejandra
      codespell
      deadnix
      llvmPackages_15.clang
      llvmPackages_15.libclang
      nodePackages.alex
      nodePackages.bash-language-server
      nodePackages.prettier
      nodePackages.pyright
      pylint
      rust-analyzer
      rustfmt
      shellcheck
      statix
      stylua
      sumneko-lua-language-server
      yapf
    ];
    plugins = with pkgs.vimPlugins; [
      barbar-nvim
      catppuccin-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp_luasnip
      cmp-path
      cmp-vsnip
      editorconfig-nvim
      gitsigns-nvim
      leap-nvim
      lualine-nvim
      luasnip
      nvim-cmp
      nvim-lspconfig
      null-ls-nvim
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      plenary-nvim
      telescope-nvim
      trouble-nvim
      vim-vsnip
    ];
    extraLuaConfig = ''
      require("getchoo")
    '';
  };

  xdg.configFile."nvim/lua/getchoo" = {
    source = ./config;
    recursive = true;
  };
}
