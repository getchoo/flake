{
	config,
	pkgs,
	...
}: let
	develPackages =
		if config.seth.devel.enable
		then
			with pkgs; [
				alejandra
				clang
				deadnix
				eclint
				lld
				statix
			]
		else [];

	guiApps =
		if config.seth.desktop != ""
		then
			with pkgs; [
				discord
				element-desktop
				spotify
				steam
			]
		else [];
	systemPackages =
		if !config.seth.standalone
		then with pkgs; [python311]
		else [];
in {
	imports = [
		./git.nix
		./mangohud
		./neovim
		./starship.nix
		./vim.nix
		./xdg.nix
	];

	home.packages = with pkgs;
		[
			bat
			exa
			fd
			gh
			rclone
			restic
			ripgrep
		]
		++ develPackages
		++ guiApps
		++ systemPackages;
}
