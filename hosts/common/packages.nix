{
	config,
	pkgs,
	...
}: let
	extraPkgs =
		if config.sys.gui.enable
		then with pkgs; [firefox]
		else [];
in {
	environment.systemPackages = with pkgs;
		[
			git
			neofetch
			pinentry-curses
			python310
			vim
		]
		++ extraPkgs;

	programs = {
		gnupg = {
			agent = {
				enable = true;
				pinentryFlavor = "curses";
			};
		};
	};
}
