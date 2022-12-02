{
	config,
	pkgs,
	modulesPath,
	...
}: {
	imports = [
		"${modulesPath}/profiles/minimal.nix"
	];

	users.users.seth = {
		extraGroups = ["wheel"];
		isNormalUser = true;
		hashedPassword = "$6$PbSrwbVIGtuaPbBx$RvnW/TvFLhxO9T0rc9NG8IExNXkaelh77fVsKoNmKLsKxtkCkR6Z5q9AcyLIgrodaByz1zZyQAj3.1gM7vEOv1";
		shell = pkgs.zsh;
	};

	home-manager.users.seth = {
		imports = [
			./config.nix
		];

		home.stateVersion = config.system.stateVersion;
	};
}
