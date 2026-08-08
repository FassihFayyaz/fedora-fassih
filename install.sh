#!/usr/bin/env bash
#
# fedora-fassih — master installer
#
# Runs the provisioning scripts in scripts/ in order. See README.md.
#
# Usage:
#   ./install.sh            # run everything
#   ./install.sh 01-repos   # run only scripts/01-repos.sh
#   ./install.sh 01 03      # run only scripts/01-repos.sh and scripts/03-nvidia.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

log() { printf '\033[1;34m[%s]\033[0m %s\n' "$(basename "$0")" "$*"; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

# If no args given, run every script in order.
if [[ $# -eq 0 ]]; then
    mapfile -t targets < <(find "$SCRIPTS_DIR" -maxdepth 1 -name '*.sh' -type f | sort)
else
    targets=()
    for arg in "$@"; do
        # Allow "01", "01-repos", or "01-repos.sh"
        file="$(find "$SCRIPTS_DIR" -maxdepth 1 -name "${arg}*.sh" -type f | head -n1)"
        [[ -n "$file" ]] || die "no script matches '$arg'"
        targets+=("$file")
    done
fi

[[ ${#targets[@]} -gt 0 ]] || die "no scripts found in $SCRIPTS_DIR"

for script in "${targets[@]}"; do
    log "▶ running $script"
    bash "$script"
done

log "✅ done"