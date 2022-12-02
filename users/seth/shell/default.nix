{
	config,
	pkgs,
	...
}: {
	imports = [
		./bash.nix
		./fish.nix
		./zsh
	];

	home.sessionVariables = {
		EDITOR = "nvim";
		VISUAL = "nvim";
		CARGO_HOME = "${config.xdg.dataHome}/cargo";
		RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
		LESSHISTFILE = "${config.xdg.stateHome}/less/history";
		NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
	};

	home.shellAliases = {
		ls = "exa --icons";
	};
}
