{ config, pkgs, modulesPath, ...}:

{
	imports = [
		"${modulesPath}/profiles/minimal.nix"
	];

	users.users.seth = {
		extraGroups = [ "wheel" ];
		isNormalUser = true;
		hashedPassword = "***REMOVED***";
		shell = pkgs.bash;
	};

	home-manager.users.seth = {
		imports = [
			./config.nix
		];

		home.stateVersion = config.system.stateVersion;
	};
}
