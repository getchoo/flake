{ confg, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		git
		neofetch
		nixos-option
		python310
		vim
	];
}
