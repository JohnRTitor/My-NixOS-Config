# Configure disks and zram
{ lib, pkgs, ... }:
{
  # Enable support for bcachefs
  boot.supportedFilesystems = [ "bcachefs" ];
  
  fileSystems = {
    "/".options = [ "defaults" "noatime" ]; # disable access time updates
    "/boot".options = [ "fmask=0137" "dmask=0027" ]; # restrict access to /boot
  };

  # Enable zram swap
  zramSwap = {
    enable = true;
    memoryPercent = 75;
  };
  # Settings for zram
  boot.kernel.sysctl = {
    "vm.swappiness" = 200;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
  swapDevices = [ 
    {
      device = "/dev/disk/by-uuid/713c9bb6-7612-48a9-b207-0bccf046a5ac";
      options = [ "defaults" "nofail" ];
    } # 16 Gigs swap
  ];


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
