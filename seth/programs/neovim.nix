{ config, lib, pkgs, ...}:

{
	programs.neovim = {
		enable = true;
		extraPackages = with pkgs; [
			black
			clang
			codespell
			nodePackages.alex
			nodePackages.bash-language-server
			nodePackages.prettier
			nodePackages.pyright
			python310Packages.flake8
			rust-analyzer
			rustfmt
			stylua
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
			nvim-treesitter
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
		source = ./nvim;
		recursive = true;
	};
}
