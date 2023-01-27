_: {
	services = {
		journald.extraConfig = ''
			MaxRetentionSec=1w
		'';
		resolved = {
			enable = true;
			dnssec = "allow-downgrade";
			extraConfig = ''
				[Resolve]
				DNS=1.1.1.1 1.0.0.1
				DNSOverTLS=yes
			'';
		};
	};
}
