{lib, ...}: {
	options.seth = with lib; {
		devel.enable = mkOption {
			type = types.bool;
			default = false;
			description = "install development packages for neovim lsp";
		};
	};
}
