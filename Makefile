HOSTNAME ?= $(shell hostname)
FLAKE ?= .#$(HOSTNAME)
HOME_TARGET ?= $(FLAKE)

all: nixos-rebuild home-manager-switch

nixos-rebuild:
	sudo nixos-rebuild switch --flake $(FLAKE)

home-manager-switch:
	nix run home-manager/master -- switch --flake $(HOME_TARGET)
