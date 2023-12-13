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
asRoot := if os() == "linux" { "true" } else { "false" }

default:
    @just --choose

[linux]
[macos]
[private]
rebuild subcmd root="false":
    {{ if root == "true" { "sudo " } else { "" } }}{{ rebuild }} {{ subcmd }} {{ rebuildArgs }} --flake .

[linux]
[macos]
boot:
	@just rebuild boot {{ asRoot }}

[linux]
[macos]
build:
    @just rebuild build

check:
    nix flake check

[linux]
[macos]
dry-run:
    @just rebuild dry-run

pre-commit:
    pre-commit run

[linux]
[macos]
switch:
    @just rebuild switch {{ asRoot }}

[linux]
[macos]
test:
    @just rebuild test {{ asRoot }}

update:
    nix flake update

update-input input:
    nix flake lock \
      --update-input {{ input }} \
      --commit-lock-file \
      --commit-lockfile-summary "flake: update {{ input }}"
