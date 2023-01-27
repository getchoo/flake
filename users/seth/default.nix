{
	config,
	pkgs,
	home-manager,
	...
}: {
	users.users.seth = {
		extraGroups = ["wheel"];
		isNormalUser = true;
		hashedPassword = "***REMOVED***";
		shell = pkgs.zsh;
	};

	home-manager.users.seth = {
		imports = [
			./home.nix
		];

		home.stateVersion = config.system.stateVersion;
		nixpkgs.config.allowUnfree = true;
		programs.home-manager.enable = true;
		systemd.user.startServices = true;
	};
}
