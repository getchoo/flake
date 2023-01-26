{config, ...}: {
	imports = [
		./documentation.nix
		./fonts.nix
		./locale.nix
		./options.nix
		./packages.nix
		./security.nix
		./systemd.nix
		./users.nix
	];

	config.services.kmscon.enable = true;
}
