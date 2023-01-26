{
	config,
	pkgs,
	...
}: {
	fonts = {
		fonts = with pkgs;
			if config.system.gui-stuff
			then [
				noto-fonts
				noto-fonts-extra
				noto-fonts-emoji
				noto-fonts-cjk-sans
				fira-code
				(nerdfonts.override {fonts = ["FiraCode"];})
			]
			else [];
		fontconfig.defaultFonts =
			if config.system.gui-stuff
			then {
				serif = ["Noto Serif"];
				sansSerif = ["Noto Sans"];
				emoji = ["Noto Color Emoji"];
				monospace = ["Fira Code"];
			}
			else {};
	};
}
