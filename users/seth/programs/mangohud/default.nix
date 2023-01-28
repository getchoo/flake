{
	config,
	pkgs,
	...
}: let
	homePackages =
		if config.seth.desktop != "null"
		then with pkgs; [mangohud]
		else [];
	mangohudConf =
		if config.seth.desktop != "null"
		then {
			source = ./config;
			recursive = true;
		}
		else {};
in {
	home.packages = homePackages;

	xdg.configFile.MangoHud = mangohudConf;
}
