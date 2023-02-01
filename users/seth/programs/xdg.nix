{config, ...}: {
	xdg = {
		enable = !config.seth.standalone;
	};
}
