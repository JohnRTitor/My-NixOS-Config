{ config, osConfig, lib, pkgs, pkgs-stable, pkgs-edge, pkgs-vscode-extensions, systemSettings, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  imports = [
    # system packages are imported in ./configuration.nix
    ./pkgs/user-packages.nix # user specific packages
    ./home-manager/shell.nix # shell (bash, zsh) config
    ./home-manager/xdg.nix # xdg config
    ./home-manager/git.nix # git config
    ./home-manager/starship/starship.nix # starship config
    ./home-manager/alacritty/alacritty.nix
    ./home-manager/pyprland/pyprland.nix # pyprland config wrapper
    ./home-manager/neofetch/neofetch.nix
    ./home-manager/vscode.nix
    ./home-manager/devenv.nix # development environment
    ./home-manager/nnn.nix # nnn - terminal file manager
    ./home-manager/eza.nix # eza - modern replacement for ls
    ./home-manager/thunar/thunar.nix

    ./home-manager/services.nix # services
  ]
  ++
  # Import if Virtualization is enabled
  lib.optionals (systemSettings.virtualisation) [
    ./home-manager/virt-manager/virt-manager.nix
  ];

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 1080p monitor
  # xresources.properties = {
  #   "Xcursor.size" = 24;
  #   "Xft.dpi" = 96; # for 4k - 172
  # };

  # home manager version should match the system version
  # usually not recommended to change this
  home.stateVersion = osConfig.system.stateVersion;

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
