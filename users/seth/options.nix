{
	config,
	lib,
	...
}:
with lib; {
	options.seth = with types; {
		devel-packages = mkOption {
			type = bool;
			default = false;
			description = "install development packages for neovim lsp";
		};
		gui-stuff = mkOption {
			type = bool;
			default = false;
			description = "install gui-related packages";
		};
	};
}
