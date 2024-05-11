alias b := build
alias c := check
alias dr := dry-run
alias sw := switch
alias t := test
alias u := update
alias ui := update-input

rebuildArgs := "--verbose"
rebuild := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }

default:
    @just --choose

[private]
rebuild subcmd *extraArgs="":
    {{ rebuild }} {{ subcmd }} {{ rebuildArgs }} --flake . {{ extraArgs }}

boot *extraArgs="": (rebuild "boot" extraArgs)

build *extraArgs="": (rebuild "build" extraArgs)

dry-run *extraArgs="": (rebuild "dry-run" extraArgs)

switch *extraArgs="": (rebuild "switch" extraArgs)

test *extraArgs="": (rebuild "test" extraArgs)

check *args="":
    nix flake check \
      --print-build-logs \
      --show-trace \
      --accept-flake-config \
      {{ args }}

eval system *args="":
    nix eval \
      --raw \
      '.#nixosConfigurations.{{ system }}.config.system.build.toplevel' \
      --no-allow-import-from-derivation \
      {{ args }}

update:
    nix flake update \
      --commit-lock-file \
      --commit-lockfile-summary "flake: update all inputs"

update-input input:
    nix flake lock \
      --update-input {{ input }} \
      --commit-lock-file \
      --commit-lockfile-summary "flake: update {{ input }}"

deploy system:
    nix run '.#{{ system }}'
