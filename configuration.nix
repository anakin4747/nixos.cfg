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
    extraGroups = [ "wheel" "docker" ];
  };

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  programs = {
    nano.enable = false;
    slock.enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      alsa-utils
      git
      libnotify
      acpilight
      picom
      vim
      xclip
      (pkgs.slock.overrideAttrs (oldAttrs: { patches = [ ./slock-only-black.patch ]; }))
      (pkgs.tabbed.overrideAttrs (oldAttrs: {
        patches = [
          ./tabbed-config-h.patch
          ./tabbed-remove-top-bar.patch
          (pkgs.fetchpatch {
            url = "https://tools.suckless.org/tabbed/patches/alpha/tabbed-alpha-0.9.diff";
            sha256 = "0xrgsz0az84nb6jbyxlp73668wpp4sc87raavalb69iwxzsi17fw";
          })
        ];
      }))
      (pkgs.st.overrideAttrs (oldAttrs: {
        version = "0.8.5";
        src = pkgs.fetchurl {
          url = "https://dl.suckless.org/st/st-0.8.5.tar.gz";
          sha256 = "0dxb8ksy4rcnhp5k54p7i7wwhm64ksmavf5wh90zfbyh7qh34s7a";
        };
        patches = [
          ./st-config-h.patch
          (pkgs.fetchpatch {
            url = "https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff";
            sha256 = "sha256-01/KBNbBKcFcfbcpMnev/LCzHpON3selAYNo8NUPbF4=";
          })
        ];
      }))
    ];
  };

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
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.tapping = false;
    };
    unclutter.enable = true;

    picom = {
      enable = true;
      backend = "glx";
      fade = true;
      fadeSteps = [ 1.0 1.0 ];
      fadeDelta = 1;
      vSync = true;
    };
  };

  system.stateVersion = "25.11";
}

# vi: sw=2:ts=2
