{
	config,
	pkgs,
	...
}: {
	home.packages = [
		pkgs.mangohud
	];

	xdg.configFile."MangoHud" = {
		source = ./MangoHud;
		recursive = true;
	};
}
