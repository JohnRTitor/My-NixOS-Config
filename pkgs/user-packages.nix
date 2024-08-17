# This config file is used to define user specific packages
# installed using home manager, this file is imported in ../system/users.nix
# System/Global packages should be installed in ./system-packages.nix
# Some packages/apps maybe handled by config options
# They are scattered in ../system/ ../home-manager/ and ../apps/ directories
{
  pkgs,
  pkgs-edge,
  inputs,
  ...
}: {
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
      dnsutils # `dig` + `nslookup`
      # ldns # replacement of `dig`, it provide the command `drill`
      # aria2 # A lightweight multi-protocol & multi-source command-line download utility
      # socat # replacement of openbsd-netcat
      # nmap # A utility for network discovery and security auditing
      # ipcalc  # it is a calculator for the IPv4/v6 addresses

      ## MISCELLANEOUS ##
      # cowsay
      # file

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

      ## MONITORING TOOLS ##
      btop # for CPU, RAM, and Disk monitoring
      nvtopPackages.amd # for AMD GPUs
      iotop # for disk I/O monitoring
      iftop # for network I/O monitoring

      ## GRAPHICAL APPS ##
      # Editors #
      # emacs

      # IDEs #
      android-studio
      (jetbrains.plugins.addPlugins jetbrains.phpstorm [
        "github-copilot"
        "nixidea"
      ])
      (jetbrains.plugins.addPlugins jetbrains.rust-rover [
        "github-copilot"
        "nixidea"
      ])

      # whatsapp-for-linux
      libreoffice-fresh
      deluge # Torrent client
      shotwell # GNOME image editor
      gnome.gnome-logs # GNOME log viewer
      mission-center # Taskmanager clone
      warp # file transfer, also install android app
      clapper
    ])
    ++ (with pkgs-edge; [
      # list of latest packages from nixpkgs master
      # Can be used to install latest version of some packages
      # Some packages may not be cached so.. it may take some time to build
    ]);

  services.flatpak.packages = [
    # Flatpak packages to be installed on a per user basis
    "io.github.tdesktop_x64.TDesktop" # 64Gram
    "im.riot.Riot" # Element Matrix Client
    "dev.vencord.Vesktop" # Vesktop
  ];
}
