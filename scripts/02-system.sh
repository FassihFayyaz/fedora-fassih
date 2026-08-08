#!/usr/bin/env bash
# Base system setup (graphical.target, base packages, user dirs, network).
set -euo pipefail

log() { printf '\033[1;34m[02-system]\033[0m %s\n' "$*"; }

log "Setting graphical.target as default boot target..."
sudo systemctl set-default graphical.target

log "Installing base packages..."
sudo dnf install which wget pciutils usbutils linux-firmware power-profiles-daemon

log "Installing user dirs support..."
sudo dnf install xdg-user-dirs
xdg-user-dirs-update

log "Installing and enabling NetworkManager (with wifi)..."
sudo dnf install NetworkManager NetworkManager-wifi
sudo systemctl enable --now NetworkManager
nmcli device status

log "Installing and enabling Bluetooth (bluez)..."
sudo dnf install bluez bluez-libs
sudo systemctl enable --now bluetooth