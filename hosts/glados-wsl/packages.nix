{
	confg,
	pkgs,
	...
}: {
	environment.systemPackages = with pkgs; [
		git
		neofetch
		nixos-option
		pinentry-curses
		python310
		vim
	];
}
