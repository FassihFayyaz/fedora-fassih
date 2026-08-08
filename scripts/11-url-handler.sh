#!/usr/bin/env bash
# "Open With" / URL handler setup.
# Installs xdg-utils and points the default browser at DankMaterialShell's
# browser picker (dms-open.desktop), so external links open the DMS chooser.
set -euo pipefail

log() { printf '\033[1;34m[11-url-handler]\033[0m %s\n' "$*"; }

log "Installing xdg-utils (xdg-settings, xdg-open)..."
sudo dnf install xdg-utils

log "Setting dms-open.desktop as the default web browser handler..."
xdg-settings set default-web-browser dms-open.desktop

log "Current default browser:"
xdg-settings get default-web-browser

log "Done. External links should now open via DMS's browser picker."