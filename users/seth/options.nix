{lib, ...}: {
	options.seth = with lib.types; {
		devel.enable = lib.mkOption {
			type = types.bool;
			default = false;
			description = "install development packages for neovim lsp";
		};
	};
}
