{ config, ...}:

{
	programs.git = {
		enable = true;
		extraConfig = {
			init = { defaultBranch = "main"; };
			safe = { directory = "/etc/nixos"; };
		};
		signing = {
			key = "D31BD0D494BBEE86";
			signByDefault = true;
		};
		userEmail = "getchoo@tuta.io";
		userName = "seth";
	};
}
