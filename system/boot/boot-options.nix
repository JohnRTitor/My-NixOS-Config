# This conf file is used to configure boot
{
  pkgs,
  ...
}: {
  # Enable systemd-boot
  boot.loader.systemd-boot.enable = true;
  # Bootspec needed for secureboot
  boot.bootspec.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # bootloader timeout set, also press t repeatedly in the bootmenu to set there
  boot.loader.timeout = 15;
  # use systemd initrd instead of udev
  # boot.initrd.systemd.enable = true; # does not work with bcachefs

  # boot.consoleLogLevel = 0; # configure silent boot
  boot.kernelParams = [
    "nohibernate" # disable hibernate, can't on zram swap, also skips lockscreen/login manager so not secure
    # "acpi_enforce_resources=lax" # openrgb
    # "quiet"
    # "udev.log_level=3"
    # "lockdown=integrity"
  ];

  # plymouth theme for splash screen
  boot.plymouth = {
    enable = true;
    # theme = "breeze"; # default
    # black_hud circle_hud cross_hud square_hud
    # circuit connect cuts_alt seal_2 seal_3
    theme = "matrix";
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.override {selected_themes = ["rings_2"];})
      pkgs.plymouth-matrix-theme
    ];
  };
}
