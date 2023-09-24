alias b := build
alias c := check
alias d := deploy
alias da := deploy-all
alias dr := dry-run
alias f := fmt
alias l := lint
alias p := pre-commit
alias sw := switch
alias sd := switch-and-deploy
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
    nix run .#{{ HOST }}

deploy-all: (deploy "atlas")

[linux]
dry-run:
    nixos-rebuild dry-run --verbose --flake .

[macos]
dry-run:
    darwin-rebuild dry-run --verbose --flake .

fmt:
    for fmt in "alejandra" "stylua"; do \
      pre-commit run "$fmt"; \
    done

lint:
    for linter in "nil" "statix" "deadnix"; do \
      pre-commit run "$linter"; \
    done

pre-commit:
    pre-commit run

[linux]
switch:
    sudo nixos-rebuild switch --verbose --flake .

[macos]
switch:
    darwin-rebuild switch --verbose --flake .

switch-and-deploy: switch deploy-all

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
