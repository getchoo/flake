{
	config,
	pkgs,
	...
}: let
	inherit (config.seth) desktop;
	homePackages =
		if desktop == "gnome"
		then with pkgs; [adw-gtk3] ++ (with pkgs.gnomeExtensions; [appindicator blur-my-shell caffeine])
		else [];
	dconfSettings =
		if desktop == "gnome"
		then {
			"org/gnome/shell" = {
				favorite-apps = [
					"firefox.desktop"
					"org.gnome.Nautilus.desktop"
					"discord.desktop"
				];
			};

			"org/gnome/desktop/interface" = {
				color-scheme = "prefer-dark";
			};

			"org/gnome/desktop/wm/keybindings" = {
				switch-windows = "['<Alt>Tab']";
				switch-windows-backward = "['<Shift><Alt>Tab']";
			};

			"org/gnome/shell" = {
				disable-user-extensions = false;
				enabled-extensions = [
					"appindicatorsupport@rgcjonas.gmail.com"
					"appindicatorsupport@rgcjonas.gmail.com"
					"caffeine@patapon.info"
				];
			};
		}
		else {};
	gtkConfig =
		if desktop == "gnome"
		then {
			enable = true;

			theme = {
				name = "adw-gtk3";
				package = pkgs.adw-gtk3;
			};

			gtk3.extraConfig = {
				Settings = ''
					gtk-application-prefer-dark-theme=1
				'';
			};

			gtk4.extraConfig = {
				Settings = ''
					gtk-application-prefer-dark-theme=1
				'';
			};
		}
		else {};
in {
	home.packages = homePackages;

	dconf.settings = dconfSettings;

	gtk = gtkConfig;
}
