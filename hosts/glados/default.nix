{
	config,
	modulesPath,
	pkgs,
	...
}: {
	imports = [
		(modulesPath + "/profiles/minimal.nix")
		../common
		../common/desktop/gnome.nix
		../common/hardware/nvidia.nix
		./boot.nix
		./network.nix
		./packages.nix
		../../users/seth
	];

	system.gui-stuff = true;

	# enable non-free packages
	nixpkgs.config.allowUnfree = true;

	# Enable nix flakes
	nix.package = pkgs.nixFlakes;
	nix.settings.experimental-features = ["nix-command" "flakes"];

	system.stateVersion = "23.05";
}
