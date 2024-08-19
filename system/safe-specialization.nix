{
  lib,
  pkgs,
  pkgs-edge,
  ...
}: {
  # Creates a second boot entry with xanmod kernel and scx disabled
  specialisation.safe.configuration = {
    system.nixos.tags = ["lqx"];
    boot.kernelPackages = lib.mkForce pkgs-edge.linuxPackages_lqx;
    chaotic.scx.enable = lib.mkForce false;
  };
}
