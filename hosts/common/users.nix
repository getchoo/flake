{
	config,
	lib,
	pkgs,
	...
}:
with config;
with lib;
with pkgs; {
	users = {
		defaultUserShell = bash;
		mutableUsers = false;

		users = {
			root = {
				home = "/root";
				uid = ids.uids.root;
				group = "root";
				initialHashedPassword = mkDefault "!";
			};
		};
	};
}
