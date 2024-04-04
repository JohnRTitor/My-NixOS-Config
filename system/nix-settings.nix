{ config, pkgs, userSettings, ... }:
{
  nix.settings.trusted-users = [ userSettings.username ]; # FIXME: see above

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

  nix.settings = {
    trusted-substituters = [
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  # cachix can be used to add cache servers
  # easily by running `cachix use <cache-name>`
  environment.systemPackages = [ pkgs.cachix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # enable nix command and flakes
  nix.settings.auto-optimise-store = true; # enable space optimisation by hardlinking

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
}