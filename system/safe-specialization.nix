{
  lib,
  pkgs,
  pkgs-master,
  ...
}: {
  # Creates a second boot entry with xanmod kernel and scx disabled
  specialisation.safe.configuration = {
    system.nixos.tags = ["xanmod"];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod_latest;
    services.scx.enable = lib.mkForce false;
  };
}
