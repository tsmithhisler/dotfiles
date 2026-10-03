# Configuration

Install GNU Stow, then run `make` from this directory to link `home/` into your home directory and install `system/` into `/`. The system step uses `sudo`. The GPP0 wake service and its script are copied into system locations; the other files use Stow links. Use `make restow` after adding or removing files, or `make unstow` to remove installed files and links. You can run `make home`, `make system`, `make restow-home`, or `make restow-system` separately.

GNOME window-switching shortcuts are saved in `home/.config/dconf/gnome-shortcuts.ini`. Run `make gnome-shortcuts` from a GNOME session to apply them. Stow links the file; dconf stores the active values separately.

WirePlumber and PipeWire configuration in `home/.config/` keeps the Bose A2DP headphones and NVIDIA HDMI as playback choices and the Blue Microphones input. A custom ALSA card profile exposes only the Blue microphone, while WirePlumber disables Bluetooth handsfree profiles, the C920 webcam microphone, and the onboard audio card. PipeWire disables discovered AirPlay sinks. After `make home`, restart both user services to apply the audio configuration:

```sh
systemctl --user restart pipewire.service wireplumber.service
```

The `system/` package also installs a systemd sleep hook that reconnects the Blue Yeti USB device (`046d:0ab7`) after resume. It takes effect after `make system` or `make restow-system`; no service needs to be enabled. Check its result after the next suspend with `journalctl -b -t reset-blue-yeti` and confirm the microphone captures audio.

`make system` and `make restow-system` install the GPP0 wake service and script as regular files, restore their SELinux labels, reload systemd, and enable and restart the service. This replaces existing Stow links, including the enabled-service link that previously pointed into `/home`. The service is available at boot before `/home` mounts.

To install or update just the wake workaround, run:

```sh
make install-wakeup
```

Check the result with:

```sh
systemctl status disable-gpp0-wakeup.service
cat /proc/acpi/wakeup
```

`GPP0` should show `*disabled`. SELinux can remain enforcing. `make unstow-system` disables the service, removes the copied files and Stow links, and reloads systemd; it does not re-enable the wake source for the running session. Desktop autostart changes take effect at the next login.
