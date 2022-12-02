{ config, pkgs, ...}:

{
	# hardware = {
	#   nvidia.package = boot.kernelPackages.nvidiaPackages.stable;
	#   xserver = {
	#     videoDrivers = [ "nvidia" ];
	#   };
	#   opengl.enable = true;
	# };

	networking.hostName = "glados";

	programs = {
		gnupg = {
			agent = {
				enable = true;
				pinentryFlavor = "curses";
			};
		};
	};
}
