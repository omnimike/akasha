.PHONY: all build install uninstall clean help

PKG_NAME = hermes-agent

all: build

build:
	makepkg -f

install:
	makepkg -i -f

uninstall:
	@if pacman -Qq $(PKG_NAME) >/dev/null 2>&1; then \
		echo "=== Removing $(PKG_NAME) from the system ==="; \
		sudo pacman -R $(PKG_NAME); \
	else \
		echo "Package '$(PKG_NAME)' is not currently installed."; \
	fi

clean:
	rm -rf pkg src *.pkg.tar*

help:
	@echo "Usage:"
	@echo "  make            Build the hermes-agent package"
	@echo "  make build      Build the hermes-agent package"
	@echo "  make install    Build and install the hermes-agent package natively via pacman"
	@echo "  make uninstall  Remove the hermes-agent package from the system"
	@echo "  make clean      Clean up generated build artifacts and package archives"
	@echo "  make help       Show this help message"
