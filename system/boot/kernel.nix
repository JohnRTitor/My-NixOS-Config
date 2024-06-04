# This config file is used to configure the kernel
{
  config,
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    # zenpower is used for reading temperature, voltage, current and power
    zenpower
  ];
}
