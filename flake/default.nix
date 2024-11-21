{
  config,
  lib,
  inputs,
  ...
}:
let 
  # bleeding edge packages from nixpkgs unstable branch, for packages that need immediate updates
  pkgs-edge = import inputs.nixpkgs-edge {
    system = config.myOptions.systemSettings.systemarch;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      android_sdk.accept_license = true;
    };
  };

  pkgs-master = import inputs.nixpkgs-master {
    system = config.myOptions.systemSettings.systemarch;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      android_sdk.accept_license = true;
    };
  };
in 
{
  imports = [
    ./hosts.nix # NixOS hosts/desktop systems are are defined there
    ./options-definitions.nix
    ../preferences.nix
  ];

  _module.args = { inherit pkgs-edge pkgs-master; };

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
      adminer-pematon-with-adminer-theme = pkgs.callPackage ../pkgs/adminer-pematon-with-adminer-theme {
        inherit (pkgs-master) adminer-pematon;
      };
    };
  };
}
