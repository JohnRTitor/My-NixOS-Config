# Configure Lanzaboote (secureboot)
{
  lib,
  pkgs,
  ...
}: {
  # Bootloader - disable systemd in favor of lanzaboote
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.systemd-boot.xbootldrMountPoint = "/boot";

  fileSystems = {
    # Workaround for lanzaboote
    "/efi/EFI/Linux" = {
      device = "/boot/EFI/Linux";
      options = ["bind"];
    };
    "/efi/EFI/nixos" = {
      device = "/boot/EFI/nixos";
      options = ["bind"];
    };
  };

  # lanzaboote for secureboot
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # enable sbctl - a frontend to create, enroll manage keys
  environment.systemPackages = [pkgs.sbctl];
}
