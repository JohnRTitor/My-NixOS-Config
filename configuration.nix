# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  pkgs-edge,
  inputs,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Include system modules
    ./system

    # include global/system packages list
    ./pkgs/global-packages.nix
    # user packages are imported in ./home.nix

    # include APPS settings
    # ./programs/openrgb.nix
    #./programs/kde-connect.nix

    # include development environment
    ./dev-environment # check ./dev-environment/default.nix for more details

    # include custom cache server settings (DANGEROUS: this will mess up nix-shell)
    #./misc/custom-cache-server.nix

    # FIXME: once devenv is updated to use --option binary-caches, remove this
    # just nix.settings.trusted-public-keys and nix.settings.trusted-substituters will be enough
    # for now: if `cachix use <repo>` is used, manually copy to ./misc/cachix dir
    ./misc/cachix.nix # absolute location /etc/nixos/cachix.nix
  ];

  networking.hostName = systemSettings.hostname; # Define your hostname in flake.nix

  # Dont change this without reading documentation
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # May cause data loss
  system.stateVersion = systemSettings.stableversion; # Did you read the comment?
}
