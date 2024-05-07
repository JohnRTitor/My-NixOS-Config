{
  imports = [
    ./hosts.nix # NixOS hosts/desktop systems are are defined there
  ];

  # Add more systems here depending on your hosts
  systems = [
    "x86_64-linux"
    # "aarch64-linux"
  ];

  # Setting this option, allows formatting via `nix fmt`
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}