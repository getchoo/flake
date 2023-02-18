{pkgs, ...}: {
	home.packages = with pkgs; [mangohud];

	xdg.configFile.MangoHud = {
		source = ./MangoHud.conf;
	};
}
