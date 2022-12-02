{ pkgs, ... }:

{
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
		bat
		clang
		exa
		fd
		lld
		ripgrep	
		python311
	];
}
