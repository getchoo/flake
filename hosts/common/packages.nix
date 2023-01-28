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
			nixos-option
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
