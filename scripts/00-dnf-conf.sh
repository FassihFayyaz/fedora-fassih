#!/usr/bin/env bash
# Optimize DNF: max_parallel_downloads=10 and defaultyes=True.
# (Equivalent to editing /etc/dnf/dnf.conf [main] section by hand.)
set -euo pipefail

log() { printf '\033[1;34m[00-dnf-conf]\033[0m %s\n' "$*"; }

log "Setting max_parallel_downloads=10..."
sudo dnf config-manager --setopt main.max_parallel_downloads=10 save

log "Setting defaultyes=True..."
sudo dnf config-manager --setopt main.defaultyes=True save

log "Resulting DNF config:"
grep -E '^\s*(max_parallel_downloads|defaultyes)' /etc/dnf/dnf.conf || true