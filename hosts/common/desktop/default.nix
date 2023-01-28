{lib, ...}: {
	environment.noXlibs = lib.mkForce false;
	programs.xwayland.enable = true;
	services.xserver.enable = true;
	xdg.portal.enable = true;
}
