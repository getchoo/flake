#!/usr/bin/env bash
set -euo pipefail
### this based on the ci script in [nixpkgs-unfree](https://github.com/numtide/nixpkgs-unfree)
### link: https://github.com/numtide/nixpkgs-unfree/blob/127b9b18583de04c6207c2a0e674abf64fc4a3b1/ci.sh
#
## MIT License
##
## Copyright (c) 2022 Jonas Chevalier
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

help="
build-outputs.sh <SYSTEM>

where
SYSTEM  is a nix system (i.e., x86_64-linux and aarch64-darwin)
"

if [ $# == 0 ]; then
	echo "$help"
	exit 1
fi
system="$1"

args=(
    --gc-roots-dir gc-roots
    --check-cache-status
    --force-recurse
    --accept-flake-config
    --option allow-import-from-derivation true
    --show-trace
    --flake
    ".#hydraJobs"
)

if [ "${GITHUB_STEP_SUMMARY-}" != "" ]; then
    log() {
        echo "$*" >> "$GITHUB_STEP_SUMMARY"
    }
else
    log() {
        echo "$*"
    }
fi

error=0

jobs=$(nix-eval-jobs "${args[@]}" | jq -r '. | @base64')
for job in "${jobs[@]}"; do
    job=$(echo "$job" | base64 -d)

    job_system=$(echo "$job" | jq -r .system)

    if [ "$job_system" != "$system" ]; then
        echo "skipping $attr since it's for $job_system and we're $system"
        continue
    fi

    attr=$(echo "$job" | jq -r .attr)

    echo "### $attr"
    error=$(echo "$job" | jq -r .error)

    if [ "$error" != "null" ]; then
        log "### ❌ $attr"
        log
        log "<details><summary>Eval error:</summary><pre>"
        log "$error"
        log "</pre></details>"
        error=1
    else
        drvPath=$(echo "$job" | jq -r .drvPath)
        if ! nix-store --realize "$drvPath" 2>&1 | tee build-log.txt; then
            log "### ❌ $attr"
            log
            log "<details><summary>Build error:</summary>last 50 lines:<pre>"
            log "$(tail -n 50 build-log.txt)"
            log "</pre></details>"
            error=1
        else
            log "### ✅ $attr"
        fi
        log
        rm build-log.txt
    fi
done

exit "$error"
