{
  imports = [
    ./host.nix

    # ./devshells.nix
    # ./formatter.nix
  ];

  # Add more systems here depending on your hosts
  systems = [
    "x86_64-linux"
    # "aarch64-linux"
  ];
}
