_: {
	imports = [
		../common/hardware/nvidia.nix
		./boot.nix
		./hardware-configuration.nix
		./network.nix
		./services.nix
	];

	sys = {
		gui.enable = true;
		desktop = "gnome";
	};
}
