{config, ...}: {
	programs.bash = {
		enable = true;
		historyFile = "${config.xdg.stateHome}/bash/history";
		historyFileSize = 1000;
		historySize = 100;
		sessionVariables = {
			EDITOR = "nvim";
			VISUAL = "nvim";
			CARGO_HOME = "${config.xdg.dataHome}/cargo";
			RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
			LESSHISTFILE = "${config.xdg.stateHome}/less/history";
			NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
		};
		shellOptions = [
			"cdspell"
			"checkjobs"
			"checkwinsize"
			"dirspell"
			"globstar"
			"histappend"
			"no_empty_cmd_completion"
		];
	};
}
