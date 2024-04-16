# This config file is used to define user specific packages
# installed using home manager, this file is imported in ../system/users.nix
# System/Global packages should be installed in ./system-packages.nix
# Some packages/apps maybe handled by config options
# They are scattered in ../system/ ../home-manager/ and ../apps/ directories

{ pkgs, pkgs-edge, ... }:
{
  home.packages = 
    (with pkgs; [
      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them

      ## ARCHIVING TOOLS ##
      zip
      unzip
      # p7zip
      gnutar
      # gzip
      # xz
      # bzip2
      # lz4
      # lzo
      # zlib
      zstd


      # utils
      # ripgrep # recursively searches directories for a regex pattern
      # jq # A lightweight and flexible command-line JSON processor
      # yq-go # yaml processer https://github.com/mikefarah/yq
      # fzf # A command-line fuzzy finder

      ## NETWORKING TOOLS ##
      # mtr # A network diagnostic tool
      # iperf3
      dnsutils  # `dig` + `nslookup`
      # ldns # replacement of `dig`, it provide the command `drill`
      # aria2 # A lightweight multi-protocol & multi-source command-line download utility
      # socat # replacement of openbsd-netcat
      # nmap # A utility for network discovery and security auditing
      # ipcalc  # it is a calculator for the IPv4/v6 addresses

      ## MISCELLANEOUS ##
      # cowsay
      # file
      # tree

      ## Productivity ##
      # hugo # static site generator
      # glow # markdown previewer in terminal

      # system call monitoring
      # strace # system call monitoring
      # ltrace # library call monitoring
      # lsof # list open files

      ## SYSTEM TOOLS ##
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb


      ## MISCELLANEOUS ##
      which
      gawk
      gnused

      ## PERSONAL ENJOYMENT ##
      ani-cli

      ## GRAPHICAL APPS ##
      # Editors #
      # emacs

      # whatsapp-for-linux
      libreoffice-fresh
      (discord.override {
        withVencord = true;
      })
      telegram-desktop_git # latest from chaotic
      deluge
      shotwell # GNOME image editor

      ## NixPkgs development ##
      nix-output-monitor
      nixpkgs-review
    ])

    ++

    (with pkgs-edge; [
      # list of latest packages from nixpkgs master
      # Can be used to install latest version of some packages
      androidStudioPackages.beta
    ])
  ;
}