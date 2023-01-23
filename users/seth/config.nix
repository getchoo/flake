_: {
	imports = [
		./options.nix
		./programs
		./shell
	];

	options.seth = {
		devel-packages = false;
		gui-stuff = false;
	};
}
