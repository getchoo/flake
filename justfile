alias b := build
alias c := check
alias d := deploy
alias da := deploy-all
alias dr := dry-run
alias p := pre-commit
alias sw := switch
alias sd := switch-and-deploy
alias t := test
alias u := update
alias ui := update-input

rebuildArgs := "--verbose"
rebuild := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }

default:
    @just --choose

[linux]
[macos]
[private]
rebuild subcmd:
    {{ rebuild }} {{ subcmd }} {{ rebuildArgs }} --flake .

[linux]
[macos]
[private]
rebuildRoot subcmd:
    {{ if os() == "macos" { "" } else { "sudo " } }} {{ rebuild }} {{ subcmd }} {{ rebuildArgs }} --flake .

[linux]
[macos]
build:
    just rebuild build

check:
    nix flake check

deploy host:
    nix run .#{{ host }}

deploy-all: (deploy "atlas")

[linux]
[macos]
dry-run:
    rebuild dry-run

pre-commit:
    pre-commit run

[linux]
[macos]
switch:
    just rebuildRoot switch

switch-and-deploy: switch deploy-all

[linux]
[macos]
test:
    just rebuildRoot test

update:
    nix flake update

update-input input:
    nix flake lock \
      --update-input {{ input }} \
      --commit-lock-file \
      --commit-lockfile-summary "flake: update {{ input }}"
