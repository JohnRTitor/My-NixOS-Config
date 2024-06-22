# This config file is used to define system/global packages
# this file is imported ../configuration.nix
# User specific packages should be installed in ./user-packages.nix
# Some packages/apps maybe handled by config options
# They are scattered in ../system/ ../home-manager/ and ../programs/ directories
{
  pkgs,
  pkgs-edge,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  environment.systemPackages =
    (with pkgs; [
      # System Packages
      # firewalld
      git # obviously
      glib # for gsettings to work
      gpgme # gnupg # for encryption and auth keys
      libappindicator
      libnotify
      openssh # for ssh

      ## URL FETCH TOOLS ##
      curl
      wget

      (callPackage ./fhs-shell.nix {})
      (callPackage ./gparted-wrapper.nix {})
    ])
    ++ (with pkgs-edge; [
      # list of latest packages from nixpkgs master
      # Can be used to install latest version of some packages
    ]);
  services.flatpak.packages = [
    # Flatpak packages to be installed systemwide
  ];
}
