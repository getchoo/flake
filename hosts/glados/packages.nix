{ confg, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		neofetch
		nixos-option
		python310
		vim
	];
}
