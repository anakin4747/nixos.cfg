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
      initContent = builtins.readFile ./.zshrc;
      syntaxHighlighting.enable = true;
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
      git
      gnumake
      minicfg.packages.${pkgs.system}.default
      opencode
      vim
    ];
  };
}

# vim: sw=2:ts=2
