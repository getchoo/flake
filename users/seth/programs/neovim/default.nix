{
	config,
	pkgs,
	...
}: let
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
				nvim-tree-lua
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
				nvim-web-devicons
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
				lualine-nvim
				catppuccin-nvim
				barbar-nvim
				lightspeed-nvim
			]
			++ lspPlugins;
	};

	xdg.configFile.nvim = {
		source = ./config;
		recursive = true;
	};
}
