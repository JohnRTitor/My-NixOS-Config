{
  config,
  lib,
  pkgs,
  pkgs-edge,
  userSettings,
  ...
}: {
  # Configure the build environment

  # Containers and adb should be available by default
  imports = [
    ./adb-toolchain.nix
    # ./nginx.nix # disable temporarily

    # Use devenv instead, it's more flexible
    # and contains a lot of prebuilt packages
    # configured in home manager

    # ./deprecated/c-toolchain.nix
    ./deprecated/php.nix
  ];
  environment.systemPackages = with pkgs; [
    rustup
  ];
}
