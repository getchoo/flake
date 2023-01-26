{
	modulesPath,
	pkgs,
	...
}: {
	imports = [
		(modulesPath + "/profiles/base.nix")
		../common
		../common/desktop/gnome.nix
		../common/hardware/nvidia.nix
		./boot.nix
		./network.nix
		./packages.nix
		./services.nix
		../../users/seth
	];

	# enable non-free packages
	nixpkgs.config.allowUnfree = true;

	# Enable nix flakes
	nix.package = pkgs.nixFlakes;
	nix.settings.experimental-features = ["nix-command" "flakes"];

	system.stateVersion = "23.05";
	sys.gui.enable = true;
}
