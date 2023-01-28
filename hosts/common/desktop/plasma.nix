{
	config,
	pkgs,
	...
}:
if config.sys.desktop == "plasma"
then {
	services.xserver = {
		displayManager.sddm.enable = true;
		desktopManager.plasma5 = {
			enable = true;
			excludePackages = with pkgs.libsForQt5; [
				elisa
				khelpcenter
				oxygen
				plasma-browser-integration
				print-manager
			];
		};
	};
}
else {}
