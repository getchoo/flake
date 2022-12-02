{
	config,
	nix,
	...
}: {
	programs.vim = {
		enable = true;
		settings = {
			expandtab = false;
			shiftwidth = 2;
			tabstop = 2;
		};
	};
}
