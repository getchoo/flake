{
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-22.11";
		nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
		nixos-wsl.url = "git+https://github.com/nix-community/NixOS-WSL?ref=main";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		nixos-hardware.url = "git+https://github.com/nixos/nixos-hardware";
		lanzaboote.url = "github:nix-community/lanzaboote";
	};

	outputs = inputs @ {
		home-manager,
		lanzaboote,
		nixos-hardware,
		nixos-wsl,
		nixpkgs,
		nixpkgsUnstable,
		...
	}: let
		util = import ./util {inherit inputs home-manager;};
		inherit (util) host user;
	in {
		homeConfigurations = {
			seth = user.mkHMUser {
				username = "seth";
				stateVersion = "23.05";
				channel = nixpkgsUnstable;
				modules = [
					({config, ...}: {
						config.seth.standalone = true;
					})
				];
			};
		};

		nixosConfigurations =
			(host.mkHost {
				name = "glados";
				modules = [
					nixos-hardware.nixosModules.common-cpu-amd-pstate
					nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
					nixos-hardware.nixosModules.common-pc-ssd
					lanzaboote.nixosModules.lanzaboote

					./users/seth
				];

				version = "23.05";
				pkgs = nixpkgsUnstable;
			})
			// (host.mkHost {
				name = "glados-wsl";
				modules = [
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

					./users/seth
				];

				pkgs = nixpkgs;
			});
	};
}
