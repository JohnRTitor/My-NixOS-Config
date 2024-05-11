{
  config,
  osConfig,
  lib,
  pkgs,
  pkgs-edge,
  systemSettings,
  userSettings,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  imports =
    [
      # system packages are imported in ./configuration.nix
      ../pkgs/user-packages.nix # user specific packages
      ./shell.nix # shell (bash, zsh) config
      ./xdg.nix # xdg config
      ./git.nix # git config
      ./starship.nix # starship config
      ./alacritty.nix
      ./fastfetch/fastfetch.nix
      ./vscode.nix
      ./devenv.nix # development environment
      ./nnn.nix # nnn - terminal file manager
      ./eza.nix # eza - modern replacement for ls
      ./thunar.nix

      ./nix-helpers.nix

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
