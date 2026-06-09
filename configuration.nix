{ pkgs, ... }:

{
  imports = [ ./boards/x1-carbon-thinkpad-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];  # usually set automatically

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    stage2Greeting = "";
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  networking = {
    hostName = "lwa";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 53317 ];
    firewall.allowedUDPPorts = [ 53317 ];
  };

  hardware.bluetooth.enable = true;

  users.users.kin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "input" ];
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
      (pkgs.slock.overrideAttrs (oldAttrs: { patches = [ ./patches/slock-only-black.patch ]; }))
      (pkgs.tabbed.overrideAttrs (oldAttrs: {
        patches = [
          ./patches/tabbed-config-h.patch
          ./patches/tabbed-remove-top-bar.patch
          (pkgs.fetchpatch {
            url = "https://tools.suckless.org/tabbed/patches/alpha/tabbed-alpha-0.9.diff";
            sha256 = "1hmr1ikn1hjjs28mirqmb4b5y1pfd896vfmz42vjrpa8ingxj6q2";
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
          ./patches/st-config-h.patch
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
      enableTearFree = true;
      windowManager.awesome.enable = true;
      xkb = {
        layout = "us";
        options = "caps:escape";
      };
    };
    displayManager = {
      ly = {
        enable = true;
        settings = {
          hide_borders = true;
          hide_key_hints = true;
          hide_keyboard_locks = true;
          hide_version_string = true;
          box_title = null;
          show_tty = false;
          clock = null;
          battery_id = null;
          animation = "none";
          blank_box = true;
          bg = 4473924; # 0x444444 dark grey box; outer bg falls back to TTY default (black)
        };
      };
      defaultSession = "none+awesome";
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.tapping = true;
      touchpad.tappingDragLock = true;
      touchpad.scrollMethod = "twofinger";
      touchpad.disableWhileTyping = true;
      touchpad.accelProfile = "adaptive";
    };
    unclutter.enable = true;
    usbmuxd.enable = true; # apple mobile device support

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
