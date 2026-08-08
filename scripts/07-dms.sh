#!/usr/bin/env bash
# Install niri + DankMaterialShell (DMS) + dms-greeter via the DankLinux installer.
#
# The installer is interactive (a wizard). During the wizard select:
#   * Niri as the window manager
#   * Alacritty as the terminal emulator
#   * dms-greeter as the display manager/greeter (a greetd greeter)
#
# Note: graphical.target is already set in 02-system.sh (idempotent), so it is
# not repeated here. A reboot after this script is required.
set -euo pipefail

log() { printf '\033[1;34m[07-dms]\033[0m %s\n' "$*"; }

log "Running the DankLinux installer (interactive wizard)..."
log "  -> select Niri, Alacritty, dms-greeter"
bash -c 'curl -fsSL https://install.danklinux.com | sh'

printf '\n'
log "Setup complete. A reboot is required to start on the niri desktop."
log "After boot, continue with the next script (or any remaining steps)."