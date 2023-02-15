{
	config,
	pkgs,
	...
}: let
	homePackages =
		if config.seth.desktop != ""
		then with pkgs; [mangohud]
		else [];
	mangohudConf =
		if config.seth.desktop != ""
		then {
			source = ./MangoHud.conf;
		}
		else {};
in {
	home.packages = homePackages;

	# xdg.configFile.MangoHud = mangohudConf;
}
