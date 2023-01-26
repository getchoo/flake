{
	config,
	pkgs,
	...
}: {
	services =
		if config.system.gui-stuff
		then {
			xserver.enable = true;
			xserver.displayManager.gdm.enable = true;
			xserver.desktopManager.gnome.enable = true;
		}
		else {};

	environment.gnome.excludePackages = (
		with pkgs;
			if config.system.gui-stuff
			then [
				epiphany
				gnome-tour
			]
			else []
	);
}
