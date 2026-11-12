#!/bin/bash
# Prints the entries in the given list files, one per line.
# Blank lines, comments and an optional leading "wget" are ignored, so lines
# can be pasted directly from the Intel release notes.
set -euo pipefail

sed -E -e 's/#.*//' -e 's/^[[:space:]]*(wget[[:space:]]+)?//' -e 's/[[:space:]]+$//' -e '/^$/d' "$@"
