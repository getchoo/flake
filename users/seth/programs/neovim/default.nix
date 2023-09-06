{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.programs.neovim;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.programs.neovim.enable = mkEnableOption "neovim" // {default = true;};

  config = mkIf cfg.enable {
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
        nil
        nodePackages.alex
        shellcheck
        statix
        stylua
        sumneko-lua-language-server
      ];
      plugins = with pkgs.vimPlugins; [
        # general
        catppuccin-nvim

        # TODO: don't pin when deprecation notice
        # is no longer in nixpkgs
        (fidget-nvim.overrideAttrs (_: {
          src = pkgs.fetchFromGitHub {
            owner = "j-hui";
            repo = "fidget.nvim";
            rev = "41f327b53c7977d47aee56f05e0bdbb4b994c5eb";
            hash = "sha256-v9qARsW8Gozit4Z3+igiemjI467QgRhwM+crqwO9r6U=";
          };
        }))

        flash-nvim
        gitsigns-nvim
        indent-blankline-nvim
        lualine-nvim
        neo-tree-nvim
        nvim-web-devicons
        mini-nvim

        # completion
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp_luasnip
        cmp-async-path
        luasnip

        # ui
        dressing-nvim
        noice-nvim
        nui-nvim
        nvim-notify

        # lsp
        nvim-lspconfig
        null-ls-nvim
        pkgs.vim-just

        ## utils
        bufferline-nvim
        plenary-nvim
        telescope-nvim
        trouble-nvim
        which-key-nvim

        # treesitter
        nvim-treesitter.withAllGrammars
        nvim-ts-context-commentstring
      ];
      extraLuaConfig = ''
        require("getchoo")
      '';
    };

    xdg.configFile."nvim/lua/getchoo" = {
      source = ./config;
      recursive = true;
    };
  };
}
