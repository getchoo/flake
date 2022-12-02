{
	lib,
	config,
	...
}:
with builtins;
with lib; {
	security.sudo = {
		configFile = ''
			Defaults	env_reset
			Defaults	secure_path = /run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin
			Defaults	editor = /run/current-system/sw/bin/vim,!env_editor
		'';
		execWheelOnly = true;
		extraRules = [
			{
				users = ["root"];
				groups = ["root"];
				commands = ["ALL"];
			}
			{
				users = ["seth"];
				commands = ["ALL"];
			}
		];
	};
}
