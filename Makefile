STOW ?= stow

.PHONY: all home system unstow unstow-home unstow-system restow restow-home restow-system

all: home system

home:
	$(STOW) --target="$(HOME)" home

system:
	sudo $(STOW) --target=/ system

unstow: unstow-home unstow-system

unstow-home:
	$(STOW) --target="$(HOME)" --delete home

unstow-system:
	sudo $(STOW) --target=/ --delete system

restow: restow-home restow-system

restow-home:
	$(STOW) --target="$(HOME)" --restow home

restow-system:
	sudo $(STOW) --target=/ --restow system
