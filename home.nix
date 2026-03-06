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
  };

  xdg.configFile."nvim".source = minicfg;
  xdg.configFile."awesome/rc.lua".source = ./rc.lua;
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
      feh
      gh
      git
      gnumake
      minicfg.packages.${pkgs.system}.default
      opencode
      vim
      wget
    ];
  };
}

# vim: sw=2:ts=2:et
