{lib, ...}: {
	options.system = with lib.types; {
		devel-packages = lib.mkOption {
			type = bool;
			default = false;
			description = "install development packages for neovim lsp";
		};
		gui-stuff = lib.mkOption {
			type = bool;
			default = false;
			description = "install gui-related packages";
		};
	};
}
