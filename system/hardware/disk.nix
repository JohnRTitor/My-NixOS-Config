# Configure disks and zram
{pkgs, ...}: {
  # Enable support for bcachefs
  boot.supportedFilesystems = ["bcachefs"];

  fileSystems = {
    "/".options = [
      "defaults"
      "noatime"
    ]; # disable access time updates
    "/boot".options = [
      "fmask=0137"
      "dmask=0027"
    ]; # restrict access to /boot
  };

  # Enable zram swap
  zramSwap = {
    enable = true;
    # this means that maximum 200% worth of physical memory size
    # can be utilised in zram, by using compression
    # this does not mean 200% of actual physical memory is used
    memoryPercent = 200;
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/90c8cb42-7424-467c-927a-0d6a63d5b2a2";
      options = [
        "defaults"
        "nofail"
      ];
      randomEncryption = {
        enable = true;
        keySize = 512;
      };
    } # 16 Gigs swap
  ];

  boot.kernel.sysctl = {
    # Setting High swappiness can improve performance with zram
    "vm.swappiness" = 200;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
    # Improve write and read performance
    # by caching pages in RAM
    # may cause OOM on large package builds
    # "vm.dirty_background_ratio" = 12;
  };

  # fstrim for SSD
  services.fstrim = {
    enable = true;
    interval = "monthly";
  };

  # Automount USB and drives
  # for virtual file systems, removable media, and remote filesystems
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.gnome-disks.enable = true;
  environment.systemPackages = with pkgs; [
    baobab # disk usage analyzer
    fuseiso # to mount iso system images
    udiskie # automount usb drives
  ];
}
