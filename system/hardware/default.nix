{
  config,
  lib,
  servicesSettings,
  ...
}: {
  imports =
    [
      ./audio.nix
      ./bluetooth.nix
      ./disk.nix
      ./graphics.nix
    ]
    ++ lib.optionals servicesSettings.tpm [./tpm.nix];

  services.ucodenix = {
    enable = true;
    # Use `cpuid | sed -n 's/^.*processor serial number = //p' | head -n1`
    # to get the serial number of your CPU
    cpuSerialNumber = "00A6-0F12-0000-0000-0000-0000";
  };
}
