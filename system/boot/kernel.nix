# This config file is used to configure the kernel
{
  config,
  pkgs,
  pkgs-edge,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
}
