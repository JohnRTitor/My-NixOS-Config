{
  description = "NixOS configuration of JohnRTitor (Hyprland, Secure-Boot)";

  # Main sources and repositories
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; # Unstable NixOS system (default)
    nixpkgs-edge.url = "nixpkgs/nixos-unstable-small"; # For latest packages
    nixpkgs-master.url = "nixpkgs/master"; # Testing branch of nixpkgs
    nixpkgs-jupyter-service-fix.url = "github:nixos/nixpkgs/refs/pull/367106/merge";

    flake-parts = {
      url = "github:hercules-ci/flake-parts"; # Flake parts for easy flake management
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Determinate, Nix by Determinate Systems
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*.tar.gz";

    # Don't add follows nixpkgs, else will cause local rebuilds
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # Bleeding edge packages from chaotic nyx, especially CachyOS kernel

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
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.5.1"; # Declarative Flatpak support for NixOS

    ## DESKTOP ENVIRONMENT ##
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # Hyprland, a Wayland WM, use git submodules too
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## MISC PACKAGES ##

    ucodenix.url = "github:e-tho/ucodenix";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions"; # Grab latest VScode extensions as a package;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR"; # Nix User Repository, for community packages
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} {imports = [./flake];};

  # Allows the user to use our cache when using `nix run <thisFlake>`.
  nixConfig = {
    extra-substituters = [
      "https://nyx.chaotic.cx/"
      "https://devenv.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
