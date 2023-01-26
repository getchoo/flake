{
	config,
	pkgs,
	...
}: let
	guiFonts =
		if config.sys.gui.enable
		then
			with pkgs; [
				noto-fonts
				noto-fonts-extra
				noto-fonts-emoji
				noto-fonts-cjk-sans
				fira-code
				(nerdfonts.override {fonts = ["FiraCode"];})
			]
		else [];

	guiDefaultFonts =
		if config.sys.gui.enable
		then {
			serif = ["Noto Serif"];
			sansSerif = ["Noto Sans"];
			emoji = ["Noto Color Emoji"];
			monospace = ["Fira Code"];
		}
		else {};
in {
	fonts = {
		enableDefaultFonts = true;
		fonts = guiFonts;
		fontconfig.defaultFonts = guiDefaultFonts;
	};
}
