{pkgs, ...}: {
	programs.neovim = {
		enable = true;
		extraPackages = with pkgs; [
			alejandra
			clang
			codespell
			deadnix
			nodePackages.alex
			nodePackages.bash-language-server
			nodePackages.prettier
			nodePackages.pyright
			pylint
			rust-analyzer
			rustfmt
			statix
			stylua
			sumneko-lua-language-server
			yapf
		];
		plugins = with pkgs.vimPlugins; [
			lualine-nvim
			catppuccin-nvim
			barbar-nvim
			lightspeed-nvim
			nvim-tree-lua
			nvim-lspconfig
			null-ls-nvim
			plenary-nvim
			(nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
			nvim-cmp
			cmp-nvim-lsp
			cmp-buffer
			cmp-path
			cmp-vsnip
			vim-vsnip
			luasnip
			cmp_luasnip
			trouble-nvim
			nvim-web-devicons
			telescope-nvim
			gitsigns-nvim
			editorconfig-nvim
		];
	};

	xdg.configFile.nvim = {
		source = ./config;
		recursive = true;
	};
}
