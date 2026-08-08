#!/usr/bin/env bash
# XDG Desktop Portals: install backends + configure preferred default.
#
# Ensures Flatpak apps / screenshots / screencasts work on Wayland (niri via wlr).
set -euo pipefail

log() { printf '\033[1;34m[08-portals]\033[0m %s\n' "$*"; }

log "Installing portal backends..."
sudo dnf install \
    xdg-desktop-portal \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-wlr

log "Writing ~/.config/xdg-desktop-portal/portal.conf..."
mkdir -p "$HOME/.config/xdg-desktop-portal"
# default=gnome (single backend) is what makes Steam's "Add Non-Steam Game"
# file picker appear. default=gnome;gtk left the FileChooser unbound and the
# dialog never mapped. Keep it as a single gnome backend.
cat > "$HOME/.config/xdg-desktop-portal/portal.conf" <<'EOF'
[preferred]
default=gnome
org.freedesktop.impl.portal.Screenshot=wlr
org.freedesktop.impl.portal.ScreenCast=wlr
EOF

log "Portal config written:"
cat "$HOME/.config/xdg-desktop-portal/portal.conf"

log "Tip: restart niri (or log out/in) so the portal backend picks up the new config."