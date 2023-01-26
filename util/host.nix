{lib, ...}:
with lib; {
	mkHost = {
		name,
		modules,
		system ? "x86_64-linux",
		pkgs,
	}:
		nixosSystem {
			inherit system;
			modules =
				[
					../hosts/common

					{
						nixpkgs.pkgs = pkgs;
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
