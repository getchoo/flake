_: {
	imports = [
		../common/desktop/gnome.nix
		../common/hardware/nvidia.nix
		./boot.nix
		./network.nix
		./packages.nix
		./services.nix
	];

	sys.gui.enable = true;
}
