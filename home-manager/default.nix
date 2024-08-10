{
  config,
  osConfig,
  lib,
  pkgs,
  pkgs-edge,
  inputs,
  systemSettings,
  userSettings,
  ...
}: {
  imports =
    [
      # system packages are imported in ./configuration.nix
      ../pkgs/user-packages.nix # user specific packages
      ./shell # shell (bash, zsh) and starship config
      ./xdg.nix # xdg config
      ./git.nix # git config
      ./alacritty.nix
      ./vscode.nix
      ./devenv.nix # development environment
      ./cli-tools.nix # Useful CLI tools
      # ./thunar.nix

      ./nix-tools.nix

      ./services.nix # services
    ]
    ++ lib.optionals osConfig.programs.thunar.enable [./thunar.nix]
    ++ lib.optionals systemSettings.virtualisation [./virt-manager.nix];

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  # home manager version should match the system version
  # usually not recommended to change this
  home.stateVersion = osConfig.system.stateVersion;
}
