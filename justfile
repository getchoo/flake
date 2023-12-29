alias b := build
alias c := check
alias dr := dry-run
alias p := pre-commit
alias sw := switch
alias t := test
alias u := update
alias ui := update-input

rebuildArgs := "--verbose"
rebuild := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }
asRoot := if os() == "linux" { "true" } else { "false" }

default:
    @just --choose

[private]
rebuild subcmd root="false":
    {{ if root == "true" { "sudo " } else { "" } }}{{ rebuild }} {{ subcmd }} {{ rebuildArgs }} --flake .

boot:
    @just rebuild boot {{ asRoot }}

build:
    @just rebuild build

dry-run:
    @just rebuild dry-run

switch:
    @just rebuild switch {{ asRoot }}

test:
    @just rebuild test {{ asRoot }}

ci:
    nix run \
      --inputs-from . \
      --override-input nixpkgs nixpkgs \
      github:Mic92/nix-fast-build -- \
      --no-nom \
      --skip-cached \
      --option accept-flake-config true \
      --flake '.#hydraJobs'

check:
    nix flake check \
      --print-build-logs \
      --show-trace \
      --accept-flake-config \
      --allow-import-from-derivation

update:
    nix flake update

update-input input:
    nix flake lock \
      --update-input {{ input }} \
      --commit-lock-file \
      --commit-lockfile-summary "flake: update {{ input }}"

deploy system:
    nix run \
      --inputs-from . \
      'nixpkgs#deploy-rs' -- \
      -s '.#{{ system }}'

deploy-all:
    nix run \
      --inputs-from . \
      'nixpkgs#deploy-rs' -- -s

pre-commit:
    pre-commit run

clean:
    rm -rf \
      result* \
      repl-result-out* \
      config.tf.json \
      .terraform*
