{pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		git
		gnupg1
		neofetch
		nixos-option
		pinentry-curses
		python310
		vim
	];
}
