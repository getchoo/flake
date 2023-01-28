{
	config,
	lib,
	...
}: let
	value = config.sys.gui.enable;
	reverse = !config.sys.gui.enable;
in {
	imports = [
		./gnome.nix
		./plasma.nix
	];

	environment.noXlibs = lib.mkForce reverse;
	programs.xwayland.enable = value;
	services.xserver.enable = value;
	xdg.portal.enable = value;
}
