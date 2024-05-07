{
  description = "Flake of JohnRTitor (Hyprland, Secure-Boot)";

  # Main sources and repositories
  inputs = {
    flake-parts = {
      # Flake parts for easy flake management
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "nixpkgs/nixos-unstable"; # Unstable NixOS system (default)
    nixpkgs-edge.url = "nixpkgs/master"; # Only used for bleeding edge packages

    # Don't add follows nixpkgs, else will cause conflicts, leading to local rebuilds
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # Bleeding edge packages from chaotic nyx
    devenv.url = "github:cachix/devenv"; # Devenv flake, don't add follows nixpkgs

    lanzaboote = {
      url = "github:nix-community/lanzaboote"; # lanzaboote, used for secureboot
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # Latest Hyprland from official repo
      inputs.nixpkgs.follows = "nixpkgs"; # make sure to follow nixpkgs else it will create multiple copies of deps
    };
    hyprcursor = {
      url = "github:hyprwm/hyprcursor"; # Latest Hyprcursor from official repo
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock/9cca0dbb45941e13322ff95796f486676f061c6e"; # Latest Hyprlock from official repo
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle"; # Latest Hypridle from official repo
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyprland = {
      url = "github:hyprland-community/pyprland"; # Latest Pyprland from official repo
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar = {
      url = "github:Alexays/Waybar"; # Latest Waybar from official repo
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags"; # Latest Ags from official repo
      inputs.nixpkgs.follows = "nixpkgs";
    };

    browser-previews = {
      url = "github:nix-community/browser-previews"; # Latest Chrome stable, beta, and dev
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # Must follow nixpkgs, else will cause conflicts

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions"; # latest vs code extensions flake
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./flake ]; };
}
