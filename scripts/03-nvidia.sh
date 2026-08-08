#!/usr/bin/env bash
# Install NVIDIA driver (RPMFusion akmod-nvidia) + CUDA, then prompt for reboot.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() { printf '\033[1;34m[03-nvidia]\033[0m %s\n' "$*"; }

log "Installing NVIDIA driver + CUDA..."
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda

# Mark this step complete now, so a --resume after reboot continues at 04.
printf '%s\n' "$(basename "$0")" >> "$SCRIPT_DIR/.progress"
sort -u -o "$SCRIPT_DIR/.progress" "$SCRIPT_DIR/.progress"

printf '\n'
log "The NVIDIA kernel module was built by akmod. A reboot is required for the"
log "proprietary driver to load (replacing nouveau)."
printf '  [y] reboot now\n'
printf '  [n] continue without rebooting (driver may stay on nouveau)\n'
read -rp 'Reboot now? (y/n): ' answer
case "${answer,,}" in
    y)
        log "Rebooting. After boot, run ./install.sh --resume to continue."
        sudo systemctl reboot
        ;;
    *)
        log "Skipping reboot. You can reboot later; resume with ./install.sh --resume."
        ;;
esac