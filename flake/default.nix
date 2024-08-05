let
  inherit ((import ../preferences.nix).systemSettings) systemarch;
in {
  imports = [
    ./hosts.nix # NixOS hosts/desktop systems are are defined there
  ];

  # systems for which you want to build the `perSystem` attributes
  systems = [
    systemarch
    # "x86_64-linux"
    # "aarch64-linux"
  ];

  # Setting this option, allows formatting via `nix fmt`
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
    packages = {
      fhs-shell = pkgs.callPackage ../pkgs/fhs-shell.nix {};
    };
  };
}
