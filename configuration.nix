{ pkgs, config, modulesPath, ... }:

{
	imports = [
		"${modulesPath}/profiles/minimal.nix"
	];

	# enable non-free packages
	nixpkgs.config.allowUnfree = true;
	
	# Enable nix flakes
	nix.package = pkgs.nixFlakes;
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	
	system.stateVersion = "22.11";
}
