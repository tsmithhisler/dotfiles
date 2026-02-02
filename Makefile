.PHONY: stow_all unstow_all

stow_all:
	@for d in */ ; do \
		[ -d "$$d" ] || continue; \
		dir=$${d%/}; \
		stow -v -t ~ "$$dir"; \
	done

unstow_all:
	@for d in */ ; do \
		[ -d "$$d" ] || continue; \
		dir=$${d%/}; \
		stow -D -v -t ~ "$$dir"; \
	done
