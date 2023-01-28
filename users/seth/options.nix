{lib, ...}: {
	options.seth = with lib; {
		devel.enable = mkOption {
			type = types.bool;
			default = false;
			description = "install development packages for neovim lsp";
		};
		desktop = mkOption {
			type = types.str;
			default = "";
			description = "choose a desktop configuration";
		};
	};
}
