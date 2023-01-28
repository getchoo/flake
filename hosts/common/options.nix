{lib, ...}: {
	options.sys = with lib; {
		gui.enable = mkOption {
			type = types.bool;
			default = false;
			description = "install gui-related packages";
		};
		wsl.enable = mkOption {
			type = types.bool;
			default = false;
			description = "signifies that the flake is being installed in wsl";
		};
		desktop = mkOption {
			type = types.str;
			default = "";
			description = "set the desktop";
		};
	};
}
