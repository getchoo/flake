alias b := build
alias c := check
alias d := deploy
alias da := deploy-all
alias f := fmt
alias l := lint
alias lo := lock
alias p := pre-commit
alias sw := switch
alias t := test
alias ul := unlock

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

deploy HOST:
    nix run .#{{ HOST }}

deploy-all: (deploy "atlas") (deploy "p-body")

fmt:
    pre-commit run alejandra && pre-commit run stylua

lint:
    pre-commit run statix && pre-commit run deadnix

lock:
    git-crypt lock

pre-commit:
    pre-commit run

[linux]
switch:
    sudo nixos-rebuild switch --impure --flake .

[macos]
switch:
    darwin-rebuild switch --flake .

[linux]
test:
    sudo nixos-rebuild test --impure --flake .

[macos]
test:
    darwin-rebuild test --flake .

unlock:
    git-crypt unlock

update:
    nix flake update

update-nixpkgs:
    nix flake lock \
    	--update-input nixpkgs --update-input nixpkgsUnstable
