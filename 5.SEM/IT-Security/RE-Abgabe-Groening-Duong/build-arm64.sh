#!/usr/bin/env bash
# Baut die Anwendung als ARM64-Linux-ELF (stripped) nach artifact/validate-arm64
# Benoetigt: gcc-aarch64-linux-gnu   (apt install gcc-aarch64-linux-gnu)
set -euo pipefail
cd "$(dirname "$0")"
cc=${CC:-aarch64-linux-gnu-gcc}
"$cc" -O2 -o artifact/validate-arm64 src/validate.c src/tweetnacl.c
aarch64-linux-gnu-strip artifact/validate-arm64 2>/dev/null || strip artifact/validate-arm64 2>/dev/null || true
echo "gebaut: $(file artifact/validate-arm64 | cut -d: -f2-)"
