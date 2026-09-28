# Configuration

Install GNU Stow, then run `make` from this directory to link `home/` into your home directory and `system/` into `/`. The system step uses `sudo`. Use `make restow` after adding or removing files, or `make unstow` to remove the links. You can run `make home`, `make system`, `make restow-home`, or `make restow-system` separately.

GNOME window-switching shortcuts are saved in `home/.config/dconf/gnome-shortcuts.ini`. Run `make gnome-shortcuts` from a GNOME session to apply them. Stow links the file; dconf stores the active values separately.

After installing or changing the systemd unit, reload systemd and enable the service once:

```sh
sudo systemctl daemon-reload
sudo systemctl enable --now disable-gpp0-wakeup.service
```

After later changes to the unit or its script, temporarily set SELinux to permissive mode, then reload and restart the service:

```sh
sudo setenforce 0
sudo systemctl daemon-reload
sudo systemctl restart disable-gpp0-wakeup.service
```

`setenforce 0` affects only the running session. Run `sudo setenforce 1` afterward to restore enforcing mode. Before unstowing the system package, run `sudo systemctl disable --now disable-gpp0-wakeup.service`; run `sudo systemctl daemon-reload` afterward. Desktop autostart changes take effect at the next login.
