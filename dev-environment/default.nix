{
  config,
  lib,
  pkgs,
  pkgs-edge,
  servicesSettings,
  ...
}: {
  # Configure the build environment

  # Containers and adb should be available by default
  imports =
    [
      # Use devenv instead, it's more flexible
      # and contains a lot of prebuilt packages
      # configured in home manager

      # ./deprecated/c-toolchain.nix
      # ./deprecated/php.nix
    ]
    ++ lib.optionals servicesSettings.adb [./adb-toolchain.nix]
    ++ lib.optionals servicesSettings.nginx [
      ./nginx.nix
      ./adminer.nix
      ./mysql.nix
    ];

  programs.java.enable = true;
}
