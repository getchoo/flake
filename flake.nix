{
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-22.11";
		nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
		nixos-wsl.url = "git+https://github.com/nix-community/NixOS-WSL?ref=main";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		lanzaboote.url = "github:nix-community/lanzaboote";
	};

	outputs = inputs @ {
		self,
		nixpkgs,
		nixpkgsUnstable,
		...
	}: let
		util = import ./util;
	in {
		nixosConfigurations = {
			glados = util.host.mkHost {
				name = "glados";
				modules = [
					self.lanzaboote.nixosModules.lanzaboote

					./hosts/glados
				];
				pkgs = nixpkgsUnstable;
			};
			glados-wsl = util.host.mkHost {
				name = "glados-wsl";
				modules = [
					./hosts/glados-wsl

					self.nixos-wsl.nixosModules.wsl
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
				pkgs = nixpkgs;
			};
		};
	};
}
