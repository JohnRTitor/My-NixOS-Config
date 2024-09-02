{
  config,
  pkgs,
  pkgs-edge,
  userSettings,
  ...
}: {
  nix.package = pkgs.lix; # pkgs-edge.nixVersions.latest; # Use latest nix
  # DONOT DISABLE THIS
  nix.settings.trusted-users = [userSettings.username]; # FIXME: if someday custom cache works without this

  # Features for building
  nix.settings.system-features = [
    # Defaults
    "big-parallel"
    "benchmark"
    "kvm"
    "nixos-test"
    # Additional
    "gccarch-x86-64-v3"
    "gccarch-x86-64-v4"
    "gccarch-znver4"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ]; # enable nix command and flakes

  nix.settings.auto-optimise-store = true; # enable space optimisation by hardlinking

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  nixpkgs.config.android_sdk.accept_license = true;
}
