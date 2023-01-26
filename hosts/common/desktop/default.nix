{
	config,
	lib,
	...
}: {
	programs.xwayland.enable = true;
	xdg.portal.enable = true;
	environment.noXlibs = lib.mkForce false;
}
