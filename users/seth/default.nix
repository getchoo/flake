{
	config,
	pkgs,
	...
}: {
	config.users.users.seth = {
		extraGroups = ["wheel"];
		isNormalUser = true;
		hashedPassword = "***REMOVED***";
		shell = pkgs.zsh;
	};

	config.home-manager.users.seth = {
		imports = [
			./config.nix
		];

		home.stateVersion = config.system.stateVersion;
	};
}
