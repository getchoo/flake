{
	config,
	lib,
	...
}: let
	gui = config.sys.gui.enable;
in {
	imports = [
		./gnome.nix
		./plasma.nix
	];

	environment.noXlibs = lib.mkForce false;
	programs.xwayland.enable = gui;
	services.xserver.enable = gui;
	xdg.portal.enable = gui;
}
