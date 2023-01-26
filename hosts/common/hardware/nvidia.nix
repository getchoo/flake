{
	config,
	pkgs,
	...
}: {
	hardware = {
		nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
		opengl = {
			enable = true;
			extraPackages = with pkgs; [
				vaapiVdpau
			];
		};
	};

	services.xserver.videoDrivers = ["nvidia"];
}
