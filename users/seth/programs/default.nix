{pkgs, ...}: {
	imports = [
		./git.nix
		# ./mangohud
		./neovim
		# ./npm.nix
		./starship.nix
		./vim.nix
		./xdg.nix
	];

	home.packages = with pkgs; [
		alejandra
		bat
		clang
		deadnix
		exa
		fd
		lld
		ripgrep
		statix
		python311
	];
}
