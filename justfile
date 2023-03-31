alias b := build
alias c := check
alias sw := switch
alias up := upgrade

default:
	@just --choose

[linux]
build:
	nixos-rebuild build --flake .

[macos]
build:
	darwin-rebuild --flake .

check:
	nix flake check --impure

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
