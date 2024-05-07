{ inputs, self, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-edge;

  # ---- SYSTEM SETTINGS ---- #
  systemSettings = {
    systemarch = "x86_64-linux"; # system arch
    hostname = "Ainz-NIX"; # hostname
    timezone = "Asia/Kolkata"; # select timezone
    locale = "en_US.UTF-8"; # select locale
    localeoverride = "en_IN";
    stableversion = "24.05";
    secureboot = true;
    virtualisation = false;
    laptop = false;
  };

  # ----- USER SETTINGS ----- #
  userSettings = {
    username = "masum"; # username
    name = "Masum R."; # name/identifier
    gitname = "John Titor"; # git name
    gitemail = "50095635+JohnRTitor@users.noreply.github.com"; # git email
    gpgkey = "29B0514F4E3C1CC0"; # gpg key
    shell = "zsh"; # user default shell # choose either zsh or bash
  };

  # configure pkgs from unstable (default)
  pkgs = import nixpkgs {
    # Add zen4 support
    localSystem =
      let
        featureSupport =
          arch: nixpkgs.lib.mapAttrs (_: f: f arch) nixpkgs.lib.systems.architectures.predicates;
      in
      { system = systemSettings.systemarch; } // featureSupport "znver4";

    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  # bleeding edge packages from nixpkgs unstable branch, for packages that need immediate updates
  pkgs-edge = import nixpkgs-edge {
    system = pkgs.system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # system is built on nixos unstable 
  lib = nixpkgs.lib;
in
{
  flake = {
    nixosConfigurations.${systemSettings.hostname} = lib.nixosSystem {
      specialArgs = {
        inherit
          self
          inputs
          pkgs-edge
          systemSettings
          userSettings
          ;
      };

      modules = [
        ../configuration.nix # main nix configuration
        inputs.chaotic.nixosModules.default # chaotic nix bleeding edge packages

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        inputs.home-manager.nixosModules.default
      ] ++ lib.optional systemSettings.secureboot inputs.lanzaboote.nixosModules.lanzaboote;
    };
  };
}
