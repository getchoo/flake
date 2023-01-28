{
	config,
	pkgs,
	...
}: let
	environmentConfig =
		if config.sys.desktop == "gnome"
		then {
			gnome.excludePackages = with pkgs;
				[
					epiphany
					gnome-tour
				]
				++ (with pkgs.gnome; [
					cheese
					geary
					gnome-characters
					gnome-contacts
					gnome-music
				]);
			systemPackages = with pkgs; [adw-gtk3 blackbox-terminal];
		}
		else {};

	xserverConfig =
		if config.sys.desktop == "gnome"
		then {
			displayManager.gdm.enable = true;
			desktopManager.gnome.enable = true;
		}
		else {};
in {
	environment = environmentConfig;

	services.xserver = xserverConfig;
}
