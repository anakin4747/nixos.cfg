{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    kernelModules = [ ];
    extraModulePackages = [ ];
    initrd = {
      kernelModules = [ "dm-snapshot" "cryptd" ];
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      luks.devices."root".device =
        "/dev/disk/by-uuid/4151d776-86b4-4abd-84fd-2941ea5962e9";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/88F4-B838";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/00daf936-4c9a-4625-aae4-61b804b25876";
  }];
}

# vi: sw=2:ts=2
