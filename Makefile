HOSTNAME ?= $(shell hostname)
FLAKE ?= .#$(HOSTNAME)
HOME_TARGET ?= $(FLAKE)

all: nixos-rebuild home-manager-switch

nixos-rebuild:
	sudo nixos-rebuild switch --flake $(FLAKE)

home-manager-switch:
	nix run --experimental-features 'nix-command flakes' home-manager/master -- switch --flake $(HOME_TARGET)
