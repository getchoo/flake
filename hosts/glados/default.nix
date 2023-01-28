_: {
	imports = [
		../common/desktop/gnome.nix
		../common/hardware/nvidia.nix
		./boot.nix
		./hardware-configuration.nix
		./network.nix
		./packages.nix
		./services.nix
	];

	sys = {
		gui.enable = true;
		desktop = "gnome";
	};
}
