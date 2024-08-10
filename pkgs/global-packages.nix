# This config file is used to define system/global packages
# this file is imported ../configuration.nix
# User specific packages should be installed in ./user-packages.nix
# Some packages/apps maybe handled by config options
# They are scattered in ../system/ ../home-manager/ and ../programs/ directories
{
  self,
  pkgs,
  pkgs-edge,
  inputs,
  ...
}: {
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

      (callPackage ./gparted-wrapper.nix {})
    ])
    ++ (with pkgs-edge; [
      # list of latest packages from nixpkgs master
      # Can be used to install latest version of some packages
    ])
    ++ [
      self.packages.${pkgs.system}.fhs-shell
    ];
  services.flatpak.packages = [
    # Flatpak packages to be installed systemwide
  ];
}
