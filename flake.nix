{
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		nixos-wsl.url = "git+https://github.com/nix-community/NixOS-WSL?ref=main";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = {
		nixpkgs,
		nixos-wsl,
		home-manager,
		...
	}: {
		nixosConfigurations.glados-wsl = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
				}

				./hosts/glados-wsl

				nixos-wsl.nixosModules.wsl
				({lib, ...}: {
					environment.noXlibs = lib.mkForce false;
					wsl = {
						enable = true;
						defaultUser = "seth";
						nativeSystemd = true;
						wslConf.network.hostname = "glados-wsl";
						startMenuLaunchers = false;
						interop.includePath = false;
					};
				})
			];
		};
	};
}
