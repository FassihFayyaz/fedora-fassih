#!/usr/bin/env bash
# GNOME Keyring: auto-unlock at login + keep the login keyring password in
# sync with the account password.
#
# This is the PAM half of the keyring setup. It:
#   1. Installs gnome-keyring + PAM module + seahorse (idempotent).
#   2. Points the Secret portal provider at gnome-keyring.
#   3. Enables the 'with-pam-gnome-keyring' authselect feature so the login
#      PAM stack unlocks the login keyring at sign-in.
#   4. Ensures /etc/pam.d/passwd runs pam_gnome_keyring use_authtok so that
#      changing your account password also updates the login keyring password.
#
# greetd caveat: if you log in through greetd (e.g. dms-greeter), also check
# that greeter's PAM service for pam_gnome_keyring.so lines, because authselect
# only manages system-auth/system-login — the greeter may use its own stack.
set -euo pipefail

log() { printf '\033[1;34m[10-pam-keyring]\033[0m %s\n' "$*"; }

# --- 1. Packages -----------------------------------------------------------
log "Installing gnome-keyring + PAM module + seahorse..."
sudo dnf install gnome-keyring gnome-keyring-pam seahorse

# --- 2. Secret portal provider ---------------------------------------------
log "Ensuring the Secret portal provider is gnome-keyring..."
PORTAL_CONF="$HOME/.config/xdg-desktop-portal/portal.conf"
mkdir -p "$(dirname "$PORTAL_CONF")"
if ! grep -q 'org.freedesktop.impl.portal.Secret=gnome-keyring' "$PORTAL_CONF" 2>/dev/null; then
    printf 'org.freedesktop.impl.portal.Secret=gnome-keyring\n' >> "$PORTAL_CONF"
fi

# --- 3. authselect: keyring auto-unlock at login ---------------------------
if command -v authselect >/dev/null 2>&1; then
    log "Enabling authselect feature 'with-pam-gnome-keyring'..."
    sudo authselect enable-feature with-pam-gnome-keyring
else
    log "authselect not found — keyring unlock-at-login will not be wired up."
    log "Add pam_gnome_keyring.so to your login PAM stack manually."
fi

# --- 4. Sync keyring password with the account password --------------------
# The shipped /etc/pam.d/passwd has a *disabled* ('-' prefixed) line, so we
# only act when no active use_authtok line exists.
PASSWD_FILE="/etc/pam.d/passwd"
if ! grep -qE '^\s*password\s+optional\s+pam_gnome_keyring\.so\s+.*use_authtok' "$PASSWD_FILE" 2>/dev/null; then
    log "Adding an active pam_gnome_keyring use_authtok line to $PASSWD_FILE..."
    printf 'password   optional   pam_gnome_keyring.so use_authtok\n' | sudo tee -a "$PASSWD_FILE" >/dev/null
else
    log "$PASSWD_FILE already syncs the keyring password. Nothing to do."
fi

log "Done. On next login the keyring unlocks automatically; run 'seahorse' once"
log "and unlock with your password to seed the login keyring."
