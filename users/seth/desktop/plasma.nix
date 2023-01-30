{
	config,
	pkgs,
	...
}: let
	inherit (config.seth) desktop;
	homePackages =
		if desktop == "plasma"
		then with pkgs; [catppuccin-kde]
		else [];
in {
	home.packages = homePackages;
}
