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
        bufferline-nvim
        catppuccin-nvim
        cmp-nvim-lsp
        cmp-buffer
        cmp_luasnip
        cmp-path
        editorconfig-nvim
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
  };
}
