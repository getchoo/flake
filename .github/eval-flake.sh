#!/usr/bin/env bash
set -euo pipefail
### this is inspired by the ci script in [nixpkgs-unfree](https://github.com/numtide/nixpkgs-unfree)
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

function get_os() {
    case "$1" in
        "x86_64-linux") echo "ubuntu-latest" ;;
        "x86_64-darwin") echo "macos-latest" ;;
        "aarch64-linux") echo "ubuntu-latst" ;;
    esac
}

args=(
    --check-cache-status
    --force-recurse
    --option allow-import-from-derivation true
    --show-trace
    --flake
    '.#hydraJobs'
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

jobs=$(nix-eval-jobs "${args[@]}" | jq -r '. | @base64')
jq -n '{"include": []}' > matrix.json

had_error=0
echo "$jobs" | while read -r job; do
    job=$(echo "$job" | base64 -d)
    attr=$(echo "$job" | jq -r .attr)
    echo "## $attr"

    error=$(echo "$job" | jq -r '.error')
    if [ "$error" == null ]; then
        log "### ✅ $attr"

        system=$(echo "$job" | jq -r .system)
        isCached=$(echo "$job" | jq -r .isCached)

        jq ".include += [{\"attr\": \"$attr\", \"os\": \"$(get_os "$system")\", \"isCached\": $isCached}]" < matrix.json > matrix.json.tmp
        mv matrix.json.tmp matrix.json
    else
        log "### ❌ $attr"
        log
        log "<details><summary>Evaluation error:</summary><pre>"
        log "$error"
        log "</pre></details>"
        had_error=1
    fi
done

echo "matrix=$(jq -r 'tostring' matrix.json)" >> "$GITHUB_OUTPUT"
rm matrix.json
exit "$had_error"
