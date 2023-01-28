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
				statix
			]
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
			discord
			exa
			fd
			gh
			lld
			rclone
			restic
			ripgrep
			steam
			python311
		]
		++ develPackages;
}
