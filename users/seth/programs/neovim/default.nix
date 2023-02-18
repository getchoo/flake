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
			barbar-nvim
			catppuccin-nvim
			cmp-nvim-lsp
			cmp-buffer
			cmp_luasnip
			cmp-path
			cmp-vsnip
			editorconfig-nvim
			gitsigns-nvim
			lightspeed-nvim
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
	};

	xdg.configFile.nvim = {
		source = ./config;
		recursive = true;
	};
	xdg.configFile."nvim/init.lua" = {
		text = ''
			local cmd = vim.cmd
			local opt = vim.opt
			require("getchoo")
			vim.g.use_lsp_plugins = true
			-- text options
			opt.tabstop = 2
			opt.shiftwidth = 2
			opt.expandtab = false
			opt.smartindent = true
			opt.wrap = false

			-- appearance
			opt.syntax = "on"
			cmd("filetype plugin indent on")
			opt.termguicolors = true
			vim.api.nvim_command("colorscheme catppuccin")
		'';
	};
}
