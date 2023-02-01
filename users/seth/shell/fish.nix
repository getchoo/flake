{
	config,
	pkgs,
	...
}: {
	programs.fish = {
		enable = !config.seth.standalone;
		plugins = [
			{
				name = "autopair-fish";
				src = pkgs.fishPlugins.autopair-fish;
			}

			{
				name = "puffer-fish";
				src = pkgs.fetchFromGitHub {
					owner = "nickeb96";
					repo = "puffer-fish";
					rev = "fd0a9c95da59512beffddb3df95e64221f894631";
					sha256 = "sha256-aij48yQHeAKCoAD43rGhqW8X/qmEGGkg8B4jSeqjVU0=";
				};
			}

			{
				name = "catppuccin-fish";
				src = pkgs.fetchFromGitHub {
					owner = "catppuccin";
					repo = "fish";
					rev = "8d0b07ad927f976708a1f875eb9aacaf67876137";
					sha256 = "sha256-/JIKRRHjaO2jC0NNPBiSaLe8pR2ASv24/LFKOJoZPjk=";
				};
			}
		];
	};
}
