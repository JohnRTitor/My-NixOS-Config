{
  description = "Flake of JohnRTitor (Hyprland, Secure-Boot)";

  # Main sources and repositories
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; # Unstable NixOS system (default)
    nixpkgs-edge.url = "nixpkgs/master"; # Only used for bleeding edge packages

    flake-parts = {
      url = "github:hercules-ci/flake-parts"; # Flake parts for easy flake management
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Don't add follows nixpkgs, else will cause local rebuilds
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # Bleeding edge packages from chaotic nyx, especially CachyOS kernel
    devenv.url = "github:cachix/devenv"; # Devenv, for setting up development environments using devenv.nix

    ## SYSTEM SERVICES ##
    home-manager = {
      url = "github:nix-community/home-manager/master"; # Home Manager, manage user configuration and home directories like a pro
      inputs.nixpkgs.follows = "nixpkgs"; # Must follow nixpkgs, else will cause conflicts with the system
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote"; # Lanzaboote module used for Secure-Boot implementation
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.4.1"; # Declarative Flatpak support for NixOS

    ## DESKTOP ENVIRONMENT ##
    ags = {
      url = "github:Aylur/ags"; # Aylur GTK Shell, a widget manager/toolkit
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=4cdddcfe466cb21db81af0ac39e51cc15f574da9"; # Hyprland, a Wayland WM, use git submodules too
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.xdph.follows = "xdph";
    };
    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcursor = {
      url = "github:hyprwm/hyprcursor"; # Forget XCursor, use Hyprcursor instead!
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock/9cca0dbb45941e13322ff95796f486676f061c6e"; # Beautiful lockscreen for Hyprland
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle"; # Hypridle daemon, needed for Hyprlock
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyprland = {
      url = "github:hyprland-community/pyprland"; # Pyprland, a plugin manager for Hyprland made in Python
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallust = {
      url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev"; # Wallust, pywal alternative to get colors from wallpapers
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar = {
      url = "github:Alexays/Waybar"; # It's that bar you see on the top on Hyprland/Sway
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## MISC PACKAGES ##
    bcachefs-tools = {
      url = "github:koverstreet/bcachefs-tools";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    browser-previews = {
      url = "github:nix-community/browser-previews"; # Latest Chrome stable, beta, and dev
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions"; # Grab latest VScode extensions as a package
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} {imports = [./flake];};
}
