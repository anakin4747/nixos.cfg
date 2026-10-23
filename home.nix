{ pkgs, minicfg, cardamum, calendula, ... }:

{
  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      bashrcExtra = builtins.readFile ./rc/bashrc;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      initContent = builtins.readFile ./rc/zshrc;
      syntaxHighlighting.enable = true;
    };

    zathura = {
      enable = true;
      extraConfig = builtins.readFile ./rc/zathurarc;
    };

    lazygit = {
      enable = true;
      settings = { gui = { showCommandLog = false; }; };
    };
  };

  xdg.configFile."nvim".source = minicfg;
  xdg.configFile."awesome/rc.lua".source = ./rc/rc.lua;
  xdg.configFile."himalaya/config.toml".source = ./rc/himalaya.toml;
  xdg.configFile."calendula/config.toml".source = ./rc/calendula.toml;
  xdg.configFile."cardamum/config.toml".source = ./rc/cardamum.toml;
  xdg.configFile."clangd/config.yaml".source = ./rc/clangd.yaml;
  xdg.configFile."libinput-gestures.conf".text = ''
    gesture swipe right 3 awesome-client "require('awful').tag.viewprev()"
    gesture swipe left  3 awesome-client "require('awful').tag.viewnext()"
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = { "application/pdf" = "org.pwmt.zathura.desktop"; };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    extraConfig = ''
      allow-loopback-pinentry
      allow-preset-passphrase
    '';
  };

  home.file.".bg/frank.jpg".source = ./frank.jpg;

  home.file.".agents/skills/bash-scripting".source = ./skills/bash-scripting;

  home.file.".pam-gnupg".text = ''
    2BAC92A3B1FE2243835BBC44C2CCF87D7514995B
    FCA6B10CFAB76924E7CD9CEB704652BC0F330B46
  '';

  home = {
    stateVersion = "25.11";

    username = "kin";
    homeDirectory = "/home/kin";

    shellAliases = {
      git = "git --no-pager";
      grep = "grep --color=always";
      ls = "ls -r1Ft --color=always";
      up = "cd \"$(git rev-parse --show-toplevel 2>/dev/null)\"";
    };

    packages = with pkgs; [
      acpi
      brave
      b4
      calendula.packages.${pkgs.system}.default
      cardamum.packages.${pkgs.system}.default
      cloc
      feh
      gh
      git
      gnumake
      gnupg
      himalaya
      obs-studio
      mpv
      nmap
      imv
      kdePackages.kdenlive
      ffmpeg
      minicfg.packages.${pkgs.system}.default
      libinput-gestures
      localsend
      linux-manual
      man-pages
      man-pages-posix
      opencode
      pass
      scrot
      vim
      wget
    ];
  };
}

# vim: sw=2:ts=2:et
