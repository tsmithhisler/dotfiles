# B550I current setup

Recorded from this machine and `~/.bash_history` on 2026-09-28. History records commands, not their output, so the sequence below does not by itself prove that every command succeeded.

## Hardware and OS

- Motherboard: Gigabyte B550I AORUS PRO AX.
- GPU: NVIDIA GeForce RTX 4070 (AD104).
- OS: Fedora Linux 44 Workstation; kernel `7.2.7-200.fc44.x86_64` at the time of inspection.
- Hostname: `enterprise` (history also shows `sudo hostnamectl set-hostname enterprise`).
- Secure Boot was disabled and the platform was in Setup Mode at the time of inspection.

## NVIDIA driver installation

The shell history shows this order:

```sh
sudo dnf install kernel-devel-matched kernel-headers
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install akmod-nvidia-open
sudo reboot
```

At inspection, `akmod-nvidia-open` version `615.71.09-1.fc44`, `xorg-x11-drv-nvidia` version `615.71.09-3.fc44`, both RPM Fusion release packages, and the kernel development packages were installed. The loaded `nvidia` module reported version `615.71.09` and license `Dual MIT/GPL`; `nvidia`, `nvidia_modeset`, `nvidia_drm`, and `nvidia_uvm` were loaded. `nvidia-smi` was unavailable in the current shell, and `xorg-x11-drv-nvidia-cuda` was not installed, so the history's `nvidia-smi` entries do not confirm its current operation.

## Other setup captured in history

- Cloned this dotfiles repository over SSH, installed GNU Stow, and ran `make`, `make all`, `make system`, and `make home` at different points. See [README.md](README.md) for the current Stow workflow.
- Installed Podman and podman-compose with `sudo dnf install podman podman-compose`.
- Installed pnpm using its install script, added pnpm to `~/.bashrc`, and installed `@openai/codex` globally with pnpm.
- Set up the `disable-gpp0-wakeup.service` unit from this repository and enabled it. The history also shows `sudo setenforce 0` during wake troubleshooting; that command changes SELinux enforcement for the running session and is not recorded here as a persistent setting.
