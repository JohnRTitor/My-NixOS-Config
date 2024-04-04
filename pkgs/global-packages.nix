# This config file is used to define system/global packages
# this file is imported ../configuration.nix
# User specific packages should be installed in ./user-packages.nix
# Some packages/apps maybe handled by config options
# They are scattered in ../system/ ../home-manager/ and ../apps/ directories

{ pkgs, pkgs-edge, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
  # pkgsx86_64_v3-core are optimised packages provided by chaotic nyx repo
    (with pkgs; [

      # System Packages
      # firewalld
      ffmpeg # codecs
      git # obviously
      glib # for gsettings to work
      gpgme # gnupg # for encryption and auth keys
      libappindicator
      libnotify
      openssh # for ssh
      python3

      ## URL FETCH TOOLS ##
      curl
      wget

      ## EDITOR ##
      vim

      ## MONITORING TOOLS ##
      btop # for CPU, RAM, and Disk monitoring
      nvtopPackages.amd # for AMD GPUs
      iotop # for disk I/O monitoring
      iftop # for network I/O monitoring

      # Tool to run app images and random app binaries
      (let base = pkgs.appimageTools.defaultFhsEnvArgs; in 
        pkgs.buildFHSUserEnv (base // {
          name = "fhs"; # provides fhs command to enter in a FHS environment
          targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
          profile = "export FHS=1";
          runScript = "$SHELL";
          extraOutputsToInstall = ["dev"];
      }))

    ])

    ++

    (with pkgs-edge; [
      # list of latest packages from nixpkgs master
      # Can be used to install latest version of some packages
      
    ])
  ;
}