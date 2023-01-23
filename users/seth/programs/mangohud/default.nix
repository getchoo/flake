{
	config,
	pkgs,
	...
}: {
	home.packages = [
		pkgs.mangohud
	];

	xdg.configFile.MangoHud = {
		source = ./config;
		recursive = true;
	};
}
