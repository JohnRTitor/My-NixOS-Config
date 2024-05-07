# This config file is used to configure the kernel
{
  config,
  lib,
  pkgs,
  pkgs-stable,
  systemSettings,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  # Enable scx extra schedulers, only available for linux-cachyos
  chaotic.scx.enable = true; # by default uses rustland

  boot.extraModulePackages = with config.boot.kernelPackages; [
    # zenpower is used for reading temperature, voltage, current and power
    zenpower
  ];
}
