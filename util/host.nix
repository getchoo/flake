{home-manager, ...}: {
	mkHost = {
		name,
		modules,
		system ? "x86_64-linux",
		version ? "22.11",
		pkgs,
	}:
		with pkgs.lib;
			nixosSystem {
				inherit system;
				modules =
					[
						../hosts/common

						({pkgs, ...}: {
							system.stateVersion = version;
							networking.hostName = mkDefault name;
							# enable non-free packages
							nixpkgs.config.allowUnfree = true;

							# Enable nix flakes
							nix.package = pkgs.nixFlakes;
							nix.settings.experimental-features = ["nix-command" "flakes"];
						})

						home-manager.nixosModules.home-manager
						{
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
						}
					]
					++ modules;
			};
}
