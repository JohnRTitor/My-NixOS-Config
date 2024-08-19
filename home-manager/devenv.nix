# Contains devenv and direnv settings
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Enable devenv
  home.packages = [pkgs.devenv];
  # Configure direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.sessionVariables = lib.mkIf (config.programs.direnv.enable) {
    DIRENV_LOG_FORMAT = ""; # silence direnv logs
  };
}
