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
