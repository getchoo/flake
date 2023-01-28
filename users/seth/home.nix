{config, ...}: let
	sysDesktop = with builtins;
		if config ? config.sys.desktop
		then config.sys.desktop
		else "";
in {
	imports = [
		./options.nix
		./desktop
		./programs
		./shell
	];

	seth.devel.enable = true;
	seth.desktop = sysDesktop;
}
