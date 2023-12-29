#!/usr/bin/env bash
set -euo pipefail

args=(
    --gc-roots-dir gc-roots
    --check-cache-status
    --force-recurse
    --option allow-import-from-derivation true
    --option accept-flake-config true
    --show-trace
    --flake
    '.#hydraJobs'
)

jobs=$(nix-eval-jobs "${args[@]}" | tee eval.json | jq -s '.')

errors=$(echo "$jobs" | jq -r '.[] | select(.error)')
[ "$errors" != "" ] && exit 1

echo "$jobs" | jq -c '
	def to_os:
		if .system == "x86_64-linux" then "ubuntu-latest"
		elif .system == "x86_64-darwin" then "macos-latest"
		else null
		end;

	{
		"include": [
			.[] | {
				attr,
				isCached,
				"os": to_os
			}
		]
	}
'
