STOW ?= stow
SYSTEM_STOW = $(STOW) --no-folding --ignore='(^|/)disable-gpp0-wakeup(\.service)?$$' --target=/

.PHONY: all home system unstow unstow-home unstow-system restow restow-home restow-system gnome-shortcuts

all: home system

home:
	$(STOW) --target="$(HOME)" home

system:
	sudo $(SYSTEM_STOW) system
	$(MAKE) install-wakeup

.PHONY: install-wakeup
install-wakeup:
	sudo install -D -m 0644 system/etc/systemd/system/disable-gpp0-wakeup.service /etc/systemd/system/disable-gpp0-wakeup.service
	sudo install -D -m 0755 system/usr/local/libexec/disable-gpp0-wakeup /usr/local/libexec/disable-gpp0-wakeup
	sudo restorecon /etc/systemd/system/disable-gpp0-wakeup.service /usr/local/libexec/disable-gpp0-wakeup
	sudo systemctl daemon-reload
	sudo systemctl enable --force disable-gpp0-wakeup.service
	sudo systemctl restart disable-gpp0-wakeup.service

unstow: unstow-home unstow-system

unstow-home:
	$(STOW) --target="$(HOME)" --delete home

unstow-system:
	sudo systemctl disable --now disable-gpp0-wakeup.service
	sudo rm -f /etc/systemd/system/disable-gpp0-wakeup.service /usr/local/libexec/disable-gpp0-wakeup
	sudo systemctl daemon-reload
	sudo $(SYSTEM_STOW) --delete system

restow: restow-home restow-system

restow-home:
	$(STOW) --target="$(HOME)" --restow home

restow-system:
	sudo $(SYSTEM_STOW) --restow system
	$(MAKE) install-wakeup

gnome-shortcuts:
	dconf load /org/gnome/desktop/wm/keybindings/ < home/.config/dconf/gnome-shortcuts.ini
