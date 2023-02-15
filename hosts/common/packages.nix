{
	config,
	pkgs,
	...
}: let
	extraPkgs =
		if config.sys.gui.enable
		then with pkgs; [firefox]
		else [];

	pinentry =
		if config.sys.desktop == "gnome"
		then pkgs.pinentry-gnome
		else pkgs.pinentry-curses;
in {
	environment.systemPackages = with pkgs;
		[
			git
			neofetch
			python310
			vim
		]
		++ extraPkgs
		++ [pinentry];

	programs = {
		gnupg = {
			agent = {
				enable = true;
				pinentryFlavor =
					if config.sys.desktop == "gnome"
					then "gnome3"
					else "curses";
			};
		};
	};
}
