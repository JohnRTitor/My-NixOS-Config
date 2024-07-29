{lib, pkgs, ... }:
{
  # Creates a second boot entry with LTS kernel, stable ZFS, stable Mesa3D.
  specialisation.safe.configuration = {
    system.nixos.tags = [ "xanmod" ];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod_latest;
    chaotic.scx.enable = lib.mkForce false;
  };
}
