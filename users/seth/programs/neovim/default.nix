{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      actionlint
      alejandra
      beautysh
      codespell
      deadnix
      just
      llvmPackages_15.clang
      llvmPackages_15.libclang
      nil
      nodePackages.alex
      nodePackages.bash-language-server
      nodePackages.eslint
      nodePackages.prettier
      nodePackages.pyright
      nodePackages.typescript-language-server
      pylint
      rust-analyzer
      rustfmt
      shellcheck
      shellharden
      statix
      stylua
      sumneko-lua-language-server
      yapf
    ];
    plugins = with pkgs.vimPlugins; [
      bufferline-nvim
      catppuccin-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp_luasnip
      cmp-path
      editorconfig-nvim
      # TODO: stop pinning the `legacy` tag
      # when fidget is rewritten
      (fidget-nvim.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "j-hui";
          repo = "fidget.nvim";
          rev = "90c22e47be057562ee9566bad313ad42d622c1d3";
          hash = "sha256-ZLe54bRMctXlBo8zH9Qy6HbrkVSlGhPiXg38aAja9C8=";
        };
      }))
      gitsigns-nvim
      leap-nvim
      lualine-nvim
      luasnip
      nvim-autopairs
      nvim-cmp
      nvim-lspconfig
      null-ls-nvim
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      pkgs.vim-just
      plenary-nvim
      telescope-nvim
      trouble-nvim
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
