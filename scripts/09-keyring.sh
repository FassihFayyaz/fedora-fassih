#!/usr/bin/env bash
# Install GNOME Keyring (Secret Service provider) + set it as the portal Secret backend.
set -euo pipefail

log() { printf '\033[1;34m[09-keyring]\033[0m %s\n' "$*"; }

log "Installing GNOME Keyring + PAM module + seahorse..."
sudo dnf install gnome-keyring gnome-keyring-pam seahorse

log "Setting Secret portal provider to gnome-keyring..."
PORTAL_CONF="$HOME/.config/xdg-desktop-portal/portal.conf"
mkdir -p "$(dirname "$PORTAL_CONF")"

# Ensure the line exists (idempotent).
if ! grep -q 'org.freedesktop.impl.portal.Secret=gnome-keyring' "$PORTAL_CONF" 2>/dev/null; then
    printf 'org.freedesktop.impl.portal.Secret=gnome-keyring\n' >> "$PORTAL_CONF"
fi

log "Portal config now:"
cat "$PORTAL_CONF"

log "Tip: ensure pam_gnome_keyring is active in the greeter/login PAM stack so the"
log "keyring unlocks at login (see README for the niri/greetd note)."