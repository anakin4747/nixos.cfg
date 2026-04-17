{ pkgs, minicfg, ... }:

{
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    bash = {
      enable = true;
      bashrcExtra = builtins.readFile ./.bashrc;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      initContent = builtins.readFile ./.zshrc;
      syntaxHighlighting.enable = true;
    };

    man.generateCaches = true;
  };

  xdg.configFile."nvim".source = minicfg;
  xdg.configFile."awesome/rc.lua".source = ./rc.lua;
  xdg.configFile."libinput-gestures.conf".text = ''
    gesture swipe right 3 awesome-client "awful.tag.viewprev()"
    gesture swipe left  3 awesome-client "awful.tag.viewnext()"
  '';
  home.file.".bg/frank.jpg".source = ./frank.jpg;

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
