HOSTNAME ?= $(shell hostname)
FLAKE ?= .#$(HOSTNAME)
HOME_TARGET ?= $(FLAKE)

.PHONY: all
all: nixos home

.PHONY: nixos
nixos:
	sudo nixos-rebuild switch --flake $(FLAKE)

.PHONY: home
home:
	nix run --experimental-features 'nix-command flakes' home-manager/master -- switch --flake $(HOME_TARGET)

.PHONY: boot
boot:
	sudo nixos-rebuild boot --flake $(FLAKE)

