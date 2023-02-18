{
	config,
	pkgs,
	...
}: {
	programs.zsh = {
		enable = false;
		enableAutosuggestions = true;
		enableSyntaxHighlighting = true;
		enableVteIntegration = true;
		completionInit = ''
			autoload -Uz bashcompinit compinit
			local zdump="${config.xdg.cacheHome}/zsh/zdump"
			bashcompinit
			compinit -d "$zdump"
			if [[ ! "$zdump.zwc" -nt "$zdump" ]]
			then
				zcompile "$zdump"
			fi
			unset zdump
		'';
		defaultKeymap = "emacs";
		dotDir = ".config/zsh";
		initExtra = ''
			autoload -Uz promptinit
			prompt walters

			zmodload zsh/zutil
			zmodload zsh/complist
			zstyle ":completion::*" group-name ""
			zstyle ":completion:*" menu "select"
			zstyle ":completion:*" squeeze-slashes "true"
			zstyle ":completion::*" use-cache "true"
			zstyle ":completion::*" cache-path "$zdump"

			unsetopt beep
			unsetopt hist_beep
			unsetopt ignore_braces
			unsetopt list_beep
			setopt always_to_end
			setopt prompt_subst
			setopt share_history

			# clear backbuffer with ctrl-l
			function clear-screen-and-scrollback() {
					echoti civis >"$TTY"
					printf '%b' '\e[H\e[2J' >"$TTY"
					zle .reset-prompt
					zle -R
					printf '%b' '\e[3J' >"$TTY"
					echoti cnorm >"$TTY"
			}

			zle -N clear-screen-and-scrollback
			bindkey '^L' clear-screen-and-scrollback
		'';
		history = {
			expireDuplicatesFirst = true;
			path = "${config.xdg.stateHome}/zsh/zsh_history";
			save = 1000;
			size = 100;
		};
		plugins = [
			# {
			# 	name = "powerlevel10k";
			# 	src = pkgs.zsh-powerlevel10k;
			# 	file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
			# }

			{
				name = "zsh-completions";
				src = pkgs.zsh-completions;
				file = "share/zsh-completions/zsh-completions.plugin.zsh";
			}

			{
				name = "cattppuccin-zsh-syntax-highlighting";
				src = pkgs.fetchFromGitHub {
					owner = "catppuccin";
					repo = "zsh-syntax-highlighting";
					rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
					sha256 = "sha256-Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
				};

				file = "themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";
			}

			# {
			# 	name = "powerlevel10k-config";
			# 	src = ./files;
			# 	file = ".p10k.zsh";
			# }
		];
	};
}
