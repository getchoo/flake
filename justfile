alias b := build
alias c := check
alias d := deploy
alias da := deploy-all
alias f := fmt
alias l := lint
alias p := pre-commit
alias sw := switch
alias t := test

default:
    @just --choose

[linux]
build:
    nixos-rebuild build --flake .

[macos]
build:
    darwin-rebuild --flake .

check:
    nix flake check

deploy HOST:
    deploy .#{{ HOST }}

deploy-all: (deploy "atlas") (deploy "p-body")

fmt:
    pre-commit run alejandra && pre-commit run stylua

lint:
    pre-commit run statix && pre-commit run deadnix

pre-commit:
    pre-commit run

[linux]
switch:
    sudo nixos-rebuild switch --flake .

[macos]
switch:
    darwin-rebuild switch --flake .

[linux]
test:
    sudo nixos-rebuild test --flake .

[macos]
test:
    darwin-rebuild test --flake .

update:
    nix flake update

update-nixpkgs:
    nix flake lock \
    	--update-input nixpkgs --update-input nixpkgs-stable
