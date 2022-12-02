{ home-manager, ... }:

{
	programs.home-manager.enable = true;

	home = {
		username = "seth";
		homeDirectory = "/home/seth";
		stateVersion = "22.11";
	};

	imports = [
		./config.nix
		./options.nix
		./xdg.nix
		./programs
		./shell	      
	];

}
