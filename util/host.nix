{
	nixpkgs,
	home-manager,
	...
}: {
	mkHost = {
		name,
		modules,
		system ? "x86_64-linux",
		pkgs,
	}:
		with pkgs.lib;
			nixosSystem {
				inherit system;
				modules =
					[
						../hosts/common

						{
							networking.hostName = mkDefault name;
						}

						home-manager.nixosModules.home-manager
						{
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
						}
					]
					++ modules;
			};
}
