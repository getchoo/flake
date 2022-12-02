{ config, lib, pkgs, ... }:

with config; with lib; with pkgs;
{
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

			seth = {
				extraGroups = [ "wheel" ];
				isNormalUser = true;
				hashedPassword = "idontknowhowtosecurethis";
				shell = fish;
			};

		};
	};
}
