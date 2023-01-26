{
	config,
	lib,
	pkgs,
	...
}: {
	environment.systemPackages = with pkgs; [
		sbctl
	];

	boot = {
		kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
		kernelParams = ["nohibernate"];

		loader = {
			systemd-boot = {
				enable = lib.mkForce false;
			};
			efi.canTouchEfiVariables = true;
		};
		lanzaboote = {
			enable = true;
			pkiBundle = "/etc/secureboot";
		};

		supportedFilesystems = ["zfs"];
	};
}
