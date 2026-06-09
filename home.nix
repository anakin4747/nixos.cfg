{ pkgs, minicfg, ... }:

{
  programs = {
    # Let Home Manager install and manage itself.
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

    # man.generateCaches = true;
  };

  xdg.configFile."nvim".source = minicfg;
  xdg.configFile."awesome/rc.lua".source = ./rc/rc.lua;
  xdg.configFile."libinput-gestures.conf".text = ''
    gesture swipe right 3 awesome-client "require('awful').tag.viewprev()"
    gesture swipe left  3 awesome-client "require('awful').tag.viewnext()"
  '';
  home.file.".bg/frank.jpg".source = ./frank.jpg;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };

  home = {
    stateVersion = "25.11";

    username = "kin";
    homeDirectory = "/home/kin";

    shellAliases = {
      git = "git --no-pager";
      grep = "grep --color=always";
      ls = "ls -r1Ft --color=always";
    };

    packages = with pkgs; [
      acpi
      brave
      cloc
      feh
      gh
      git
      gnumake
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
      scrot
      vim
      wget
    ];
  };
}

# vim: sw=2:ts=2:et
