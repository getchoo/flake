{modulesPath, ...}: {
	imports = [
		(modulesPath + "/profiles/minimal.nix")
	];

	sys.wsl.enable = true;
}
