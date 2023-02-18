{
	pkgs,
	desktop,
	...
}: let
	gui = desktop != "";
in {
	fonts = {
		enableDefaultFonts = gui;
		fonts =
			if gui
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
		fontconfig.defaultFonts =
			if gui
			then {
				serif = ["Noto Serif"];
				sansSerif = ["Noto Sans"];
				emoji = ["Noto Color Emoji"];
				monospace = ["Fira Code"];
			}
			else {};
	};
}
