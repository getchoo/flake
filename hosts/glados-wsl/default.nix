{ config, modulesPath, pkgs, ...}:

{
	imports = [
		(modulesPath + "/profiles/minimal.nix")
		./config.nix
		./packages.nix
		../../users/seth
	];

	# enable non-free packages
	nixpkgs.config.allowUnfree = true;
	
	# Enable nix flakes
	nix.package = pkgs.nixFlakes;
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	
	system.stateVersion = "22.11";
}
