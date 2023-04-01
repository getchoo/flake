alias b := build
alias c := check
alias f := fmt
alias l := lint
alias p := pre-commit
alias sw := switch
alias up := upgrade

default:
	@just --choose

[linux]
build:
	nixos-rebuild build --impure --flake .

[macos]
build:
	darwin-rebuild --flake .

check:
	nix flake check --impure

fmt:
	pre-commit run alejandra && pre-commit run stylua

lint:
	pre-commit run statix && pre-commit run deadnix

pre-commit:
	pre-commit run

[linux]
switch:
	sudo nixos-rebuild switch --impure --flake .

[macos]
switch:
	darwin-rebuild switch --flake .

update:
	nix flake update

update-nixpkgs:
	nix flake lock \
		--update-input nixpkgs --update-input nixpkgsUnstable

[linux]
upgrade:
	sudo nixos-rebuild switch --upgrade --impure --flake .

[macos]
upgrade:
	darwin-rebuild switch --upgrade --flake .
