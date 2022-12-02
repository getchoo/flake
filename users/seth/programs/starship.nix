{config, ...}: {
	programs.starship = {
		enable = false;
		settings = {
			format = "" "
				$username\
				$hostname\
				$directory\
				$vcsh\
				$git_branch\
				$git_commit\
				$git_state\
				$git_metrics\
				$git_status\
				$docker_context\
				$nix_shell\
				$env_var\
				$sudo\
				$cmd_duration\
				$line_break\
				$jobs\
				$status\
				$container\
				$shell\
				$character
			" "";
		};
	};
}
