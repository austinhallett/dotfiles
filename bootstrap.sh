#!/bin/bash
set -euo pipefail

# stow  --restow bin
stow --no-folding --target="HOME" --ignore="init.sh" "shared"

platform=$(uname | tr '[:upper:]' '[:lower:]')
if [ ! -d "${platform}" ]; then
    echo "# Platform ${platform} is not supported. Aborting..."
    exit 1
else
    echo "# Bootstrapping for platform: ${platform}"
    stow --no-folding --override='.*' --target="HOME" --ignore="init.sh" "${platform}"
    if [ -f "${platform}/init.sh" ]; then
        echo "## Sourcing platform-specific init script: ${platform}/init.sh"
        # shellcheck disable=SC1091
        source "${platform}/init.sh"
    fi
fi
