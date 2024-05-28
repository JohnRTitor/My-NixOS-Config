{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ./common.nix) commonSessionVariables commonRcExtra;
in {
  imports = [./zsh-plugins.nix];

  programs.zsh = {
    enable = true;
    sessionVariables =
      commonSessionVariables
      // {
        # Add custom session variables for zsh
      };
    shellAliases = {
      # additional aliases to set for zsh
    };
    # extra lines to add to the zshrc file
    # Enable autosuggest to use history and completion
    initExtra =
      commonRcExtra
      + ''
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
