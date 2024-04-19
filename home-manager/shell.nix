# This config is used to configure the shell environment using home manager
# You can add custom aliases, session variables, and other shell configurations here

# NOTE: related global shell options like programs.zsh.enable must also be added to configuration.nix
# Else files may not be sourced properly

{ config, lib, ... }:
let
  # initial commands to run for all shells
  commonRcExtra = ''
    # Custom extraRc from home-manager/shell.nix
    # the below creates a wrapper function to print the command before executing it
    execmd() { echo "Executing: $@" && "$@" ; }
  '';
  # Define common session variables which would apply to all shells
  commonSessionVariables = {
    # Binds GPG to current tty
    GPG_TTY = "$(tty)";
    # Add custom bin directories to the PATH
    PATH = "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
  };

in {
  # Define common aliases which would apply to all shells
  home.shellAliases = {
    check-flake = "execmd nix flake check";
    update-flake = "execmd nix flake update";
    # rebuild = "execmd sudo nixos-rebuild switch"; 
    # garbage-collect = "execmd sudo nix-collect-garbage -d";
    fix-store = "execmd sudo nix-store --verify --check-contents --repair";
    # cfastfetch is just an alias to run compact fastfetch
    cfastfetch = "fastfetch --config ~/.config/fastfetch/config-compact.jsonc";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = commonRcExtra + ''
      # Custom bashrc go here, type below this line
    '';
    sessionVariables = commonSessionVariables // {
      # Add custom session variables for bash
    };

    shellAliases = {
      # set some aliases specific for bash
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    sessionVariables = commonSessionVariables // {
      # Add custom session variables for zsh
    };
    shellAliases = {
      # additional aliases to set for zsh
    };
    # extra lines to add to the zshrc file
    # Enable autosuggest to use history and completion
    initExtra = commonRcExtra + ''
      ZSH_AUTOSUGGEST_STRATEGY=(completion history match_prev_cmd)
    '';
  };

  # If starship is enabled, don't enable oh-my-zsh
  programs.zsh.oh-my-zsh = lib.mkIf (config.programs.starship.enable == false) {
    enable = true;
    plugins = [ 
      "git"
      "history"
      "urltools" # provides urlencode, urldecode
      ];
    theme = "duellj";
  };
}