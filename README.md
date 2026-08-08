# fedora-fassih

Personal provisioning scripts to take a **Fedora** install and turn it into
Fassih's working desktop setup (niri on Wayland).

These scripts document the steps taken on this machine so the setup can be
reproduced or rebuilt quickly. They assume a freshly installed **Fedora minimal /
custom** system and bash.

## Usage

Clone and run from the repo root:

```bash
git clone https://github.com/FassihFayyaz/fedora-fassih.git
cd fedora-fassih
./install.sh
```

`install.sh` runs the scripts in `scripts/` in order. You can also run
individual scripts, e.g. `./install.sh 03-nvidia`.

### Checkpoints & resume

`install.sh` records each completed script in a `.progress` file. The NVIDIA
step (`03-nvidia`) ends by asking you to reboot; after rebooting, continue from
where you left off:

```bash
./install.sh --resume
```

Running `./install.sh` with no args also detects existing progress and offers
to resume, start over, or quit.

## Scripts

| # | Script | What it does |
|---|--------|--------------|
| 0 | `scripts/00-dnf-conf.sh` | DNF speed: `max_parallel_downloads=10`, `defaultyes=True` |
| 1 | `scripts/01-repos.sh` | Enable RPMFusion **nonfree**, group upgrade core, upgrade --refresh |
| 2 | `scripts/02-system.sh` | graphical.target, base packages, user dirs, NetworkManager |
| 3 | `scripts/03-nvidia.sh` | NVIDIA driver (`akmod-nvidia`) + CUDA |
| 4 | `scripts/04-audio.sh` | PipeWire audio stack (pipewire, pulse, wireplumber) |
| 5 | `scripts/05-desktop.sh` | RPMFusion **free**, multimedia group upgrade, fastfetch |
| 6 | `scripts/06-apps.sh` | zen-browser, vesktop, media mount points, ntfs-3g, thunar, gnome-disk-utility |
| 7 | `scripts/07-dms.sh` | DankLinux installer: niri WM + Alacritty + dms-greeter (interactive), reboot |

## Requirements

- Fedora (tested on Fedora 44)
- `sudo` access
- Network access

## Related

- [dotfiles](https://github.com/FassihFayyaz/dotfiles) — the matching config
  files. Install them after provisioning.