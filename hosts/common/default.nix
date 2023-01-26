{lib, ...}: {
	imports = [
		./options.nix
		./documentation.nix
		./fonts.nix
		./locale.nix
		./security.nix
		./systemd.nix
		./users.nix
	];

	config.services.kmscon.enable = true;
}
