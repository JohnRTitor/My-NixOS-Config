# Configure printers
{
  lib,
  pkgs,
  ...
}: let
  avahiSupport = false;
in {
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    # cups-pdf.enable = true; # Enable seperate PDF printing virtual printer
    openFirewall = true; # Open ports for printing
  };
  # Enable Avahi to discover printers, and LAN devices
  services.avahi = lib.mkIf avahiSupport {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
