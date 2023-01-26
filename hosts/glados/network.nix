{config, ...}: {
	networking = {
		hostId = "$(head -c 8 /etc/machine-id)";
		networkmanager = {
			enable = true;
			dns = "systemd-resolved";
		};
	};
}
