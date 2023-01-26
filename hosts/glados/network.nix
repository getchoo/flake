{config, ...}: {
	networking = {
		hostId = "replace_me";
		networkmanager = {
			enable = true;
			dns = "systemd-resolved";
		};
	};
}
