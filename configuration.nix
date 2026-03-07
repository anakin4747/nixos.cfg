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

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      git
      libnotify
      picom
      vim
      xclip
      (pkgs.tabbed.overrideAttrs (oldAttrs: {
        patches = [
          ./tabbed-config-h.patch
          ./tabbed-remove-drawing-of-bar.patch
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
            sha256 = "10gvwnpbjw49212k25pddji08f4flal0g9rkwpvkay56w8y81r22";
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
  };

  system.stateVersion = "25.11";
}

# vi: sw=2:ts=2
