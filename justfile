alias b := build
alias c := check
alias d := deploy
alias da := deploy-all
alias dr := dry-run
alias f := fmt
alias l := lint
alias p := pre-commit
alias sw := switch
alias t := test

default:
    @just --choose

[linux]
build:
    nixos-rebuild build --verbose --flake .

[macos]
build:
    darwin-rebuild build --verbose --flake .

check:
    nix flake check

deploy HOST:
    deploy .#{{ HOST }}

deploy-all:
    deploy

[linux]
dry-run:
    nixos-rebuild dry-run --verbose --flake .

[macos]
dry-run:
    darwin-rebuild dry-run --verbose --flake .

fmt:
    pre-commit run alejandra && pre-commit run stylua

lint:
    pre-commit run statix && pre-commit run deadnix

pre-commit:
    pre-commit run

[linux]
switch:
    sudo nixos-rebuild switch --verbose --flake .

[macos]
switch:
    darwin-rebuild switch --verbose --flake .

[linux]
test:
    sudo nixos-rebuild test --verbose --flake .

[macos]
test:
    darwin-rebuild test --verbose --flake .

update:
    nix flake update

update-nixpkgs:
    nix flake lock \
    	--update-input nixpkgs --update-input nixpkgs-stable
