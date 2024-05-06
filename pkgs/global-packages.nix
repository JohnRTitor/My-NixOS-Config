# This config file is used to define system/global packages
# this file is imported ../configuration.nix
# User specific packages should be installed in ./user-packages.nix
# Some packages/apps maybe handled by config options
# They are scattered in ../system/ ../home-manager/ and ../programs/ directories

{ pkgs, pkgs-edge, ... }:
{
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

      ## EDITOR ##
      vim
    ])
    ++ (with pkgs-edge; [
      # list of latest packages from nixpkgs master
      # Can be used to install latest version of some packages
    ])
    ++ [
      (
        # Tool to run app images and random app binaries
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSUserEnv (
          base
          // {
            name = "fhs"; # provides fhs command to enter in a FHS environment
            targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
            profile = "export FHS=1";
            runScript = "$SHELL";
            extraOutputsToInstall = [ "dev" ];
          }
        )
      )
    ];
}
