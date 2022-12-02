{
	config,
	lib,
	pkgs,
	...
}: {
	programs.neovim = {
		enable = true;
		extraPackages = with pkgs; [
			alejandra
			black
			clang
			codespell
			deadnix
			nodePackages.alex
			nodePackages.bash-language-server
			nodePackages.prettier
			nodePackages.pyright
			python310Packages.flake8
			rust-analyzer
			rustfmt
			statix
			stylua
			sumneko-lua-language-server
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

	xdg.configFile."nvim" = {
		source = ./lua;
		recursive = true;
	};
}
