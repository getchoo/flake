{
	config,
	pkgs,
	...
}: let
	neovimConfig =
		if config.seth.devel.enable
		then "vim.g.use_lsp_plugins = true"
		else "vim.g.use_lsp_plugins = false";

	lspPackages =
		if config.seth.devel.enable
		then
			with pkgs; [
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
			]
		else [];

	lspPlugins =
		if config.seth.devel.enable
		then
			with pkgs.vimPlugins; [
				nvim-lspconfig
				null-ls-nvim
				plenary-nvim
				nvim-treesitter.withAllGrammars
				nvim-cmp
				cmp-nvim-lsp
				cmp-buffer
				cmp-path
				cmp-vsnip
				vim-vsnip
				luasnip
				cmp_luasnip
				trouble-nvim
				telescope-nvim
				gitsigns-nvim
				editorconfig-nvim
			]
		else [];
in {
	programs.neovim = {
		enable = true;
		extraPackages = lspPackages;
		plugins = with pkgs.vimPlugins;
			[
				barbar-nvim
				catppuccin-nvim
				lightspeed-nvim
				lualine-nvim
				nvim-tree-lua
				nvim-web-devicons
			]
			++ lspPlugins;
	};

	xdg.configFile.nvim = {
		source = ./config;
		recursive = true;
	};
	xdg.configFile."nvim/init.lua" = {
		text =
			neovimConfig
			+ ''

				local cmd = vim.cmd
				local opt = vim.opt

				require("getchoo")

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
