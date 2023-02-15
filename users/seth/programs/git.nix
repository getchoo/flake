{config, ...}: {
	programs.git = {
		enable = !config.seth.standalone;
		extraConfig = {
			init = {defaultBranch = "main";};
			safe = {directory = "/etc/nixos";};
		};
		signing = {
			key = "D31BD0D494BBEE86";
			signByDefault = true;
		};
		userEmail = "getchoo@tuta.io";
		userName = "seth";
	};
	services.gpg-agent.extraConfig = ''
		pinentry-program /run/current-system/sw/bin/pinentry
	'';
}
