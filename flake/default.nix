{
  config,
  lib,
  ...
}: {
  imports = [
    ./hosts.nix # NixOS hosts/desktop systems are are defined there
    ./options-definitions.nix
    ../preferences.nix
  ];

  # systems for which you want to build the `perSystem` attributes
  systems = lib.unique [
    config.myOptions.systemSettings.systemarch
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem = {
    pkgs,
    self',
    ...
  }: {
    # Setting this option, allows formatting via `nix fmt`
    formatter = pkgs.alejandra;

    # Packages defined in the flake, derivations usually reside in `../pkgs/`
    # Use `nix flake show` to see the list of packages
    # To access packages from this flake, use `self'.packages.<name>`
    packages = {
      fhs-shell = pkgs.callPackage ../pkgs/fhs-shell.nix {};
      weather-python-script = pkgs.callPackage ../pkgs/weather-python-script.nix {};
      adminer-pematon = pkgs.callPackage ../pkgs/adminer-pematon {};
      adminer-pematon-with-adminer-theme = pkgs.callPackage ../pkgs/adminer-pematon-with-adminer-theme {
        inherit (self'.packages) adminer-pematon;
      };
    };
  };
}
