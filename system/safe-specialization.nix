{
  lib,
  pkgs,
  ...
}: {
  # Creates a second boot entry with xanmod kernel and scx disabled
  specialisation.safe.configuration = {
    system.nixos.tags = ["xanmod"];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod_latest;
    chaotic.scx.enable = lib.mkForce false;
  };
}
