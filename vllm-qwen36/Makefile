.PHONY: all build install uninstall clean help

PKG_NAME = vllm-qwen36

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
	@echo "  make            Build the vllm-qwen36 package"
	@echo "  make build      Build the vllm-qwen36 package"
	@echo "  make install    Build and install the vllm-qwen36 package natively via pacman"
	@echo "  make uninstall  Remove the vllm-qwen36 package from the system"
	@echo "  make clean      Clean up generated build artifacts and package archives"
	@echo "  make help       Show this help message"
