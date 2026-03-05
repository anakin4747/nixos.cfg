{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "lwa";
    networkmanager.enable = true;
  };

  users.users.kin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  environment.systemPackages = with pkgs; [
    vim
    git
    xclip
    st
    # (st.overrideAttrs (oldAttrs: {
    #   patches = [
    #     (fetchpatch {
    #       url = "https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff";
    #       sha256 = "01/KBNbBKcFcfbcpMnev/LCzHpON3selAYNo8NUPbF4=";
    #     })
    #   ];
    # }))
  ];

  services = {
    xserver = {
      enable = true;
      windowManager.awesome.enable = true;
      xkb = {
        layout = "us";
        options = "caps:escape";
      };
    };
    displayManager = {
      ly.enable = true;
      defaultSession = "none+awesome";
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    libinput.enable = true;
    openssh.enable = true;
  };

  system.stateVersion = "25.11";
}

# vi: sw=2:ts=2
