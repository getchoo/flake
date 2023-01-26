{
	config,
	pkgs,
	...
}: {
	environment.systemPackages = with pkgs; [man-pages man-pages-posix nixpkgs-manual];
	documentation = {
		dev.enable = true;
		man.enable = true;
	};
}
