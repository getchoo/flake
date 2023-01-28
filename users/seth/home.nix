_: {
	imports = [
		./options.nix
		./desktop
		./programs
		./shell
	];

	seth.devel.enable = true;
	seth.desktop = "gnome";
}
