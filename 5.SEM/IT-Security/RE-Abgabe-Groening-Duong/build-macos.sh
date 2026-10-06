#!/usr/bin/env bash
# AUF einem Apple-Silicon-Mac ausfuehren -> natives arm64 Mach-O 'validate-macos'.
# (macOS nutzt Mach-O, nicht ELF; ein Mac-Binary laesst sich nur auf/fuer macOS bauen.)
set -euo pipefail
cd "$(dirname "$0")"
clang -O2 -arch arm64 -o validate-macos src/validate.c src/tweetnacl.c
strip validate-macos
echo "gebaut: $(file validate-macos | cut -d: -f2-)"
