{pkgs, ...}: {
	imports = [
		./.
	];
	environment = {
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
	};

	services.xserver = {
		displayManager.gdm.enable = true;
		desktopManager.gnome.enable = true;
	};
}
