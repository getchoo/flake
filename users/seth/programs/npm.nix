{config, ...}: {
	programs.npm = {
		enable = true;
		npmrc = ''
			prefix=${config.xdg.dataHome}/npm
			cache=${config.xdg.cacheHome}/npm
			init-module=${config.xdg.configHome}/npm/config/npm-init.js
		'';
	};
}
