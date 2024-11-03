{config, ... }:
{
  imports = [
    ./hosts.nix # NixOS hosts/desktop systems are are defined there
    ./options-definitions.nix
    ../preferences.nix
  ];

  # systems for which you want to build the `perSystem` attributes
  systems = [
    config.myOptions.systemSettings.systemarch
    # "x86_64-linux"
    # "aarch64-linux"
  ];

  # Setting this option, allows formatting via `nix fmt`
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
    packages = {
      fhs-shell = pkgs.callPackage ../pkgs/fhs-shell.nix {};
      weather-python-script = pkgs.callPackage ../pkgs/weather-python-script.nix {};
    };
  };
}
