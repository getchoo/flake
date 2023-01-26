{pkgs, ...}: {
	imports = [
		./.
	];

	services.xserver = {
		enable = true;
		displayManager.gdm.enable = true;
		desktopManager.gnome.enable = true;
	};

	environment.gnome.excludePackages = with pkgs; [
		epiphany
		gnome-tour
	];
}
