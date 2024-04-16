{
  description = "Flake of JohnRTitor (Hyprland, Secure-Boot)";

  outputs = { self, nixpkgs, nixpkgs-edge, ... }@inputs: # Also pass all inputs
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        systemarch = "x86_64-linux"; # system arch
        hostname = "Ainz-NIX"; # hostname
        timezone = "Asia/Kolkata"; # select timezone
        locale = "en_US.UTF-8"; # select locale
        localeoverride = "en_IN";
        stableversion = "24.05";
        kernel = "cachyos"; # cachyos, xanmod, zen # default: latest generic kernel
        secureboot = true;
        virtualisation = false;
        laptop = false;
      };

      # ----- USER SETTINGS ----- #
      userSettings = {
        username = "masum"; # username
        name = "Masum R."; # name/identifier
        email = "masumrezarock100@gmail.com"; # email (used for certain configurations)
        gitname = "John Titor"; # git name
        gitemail = "50095635+JohnRTitor@users.noreply.github.com"; # git email
        gpgkey = "29B0514F4E3C1CC0"; # gpg key
        shell = "zsh"; # user default shell # choose either zsh or bash
      };

      # configure pkgs from unstable (default)
      pkgs = import nixpkgs {
        # Add zen4 support
        localSystem = let
          featureSupport = arch:
          nixpkgs.lib.mapAttrs (_: f: f arch) nixpkgs.lib.systems.architectures.predicates;
        in {
          system = systemSettings.systemarch;
        } // featureSupport "znver4";

        config = { allowUnfree = true;
                  allowUnfreePredicate = (_: true); };
      };
      # bleeding edge packages from nixpkgs unstable branch, for packages that need immediate updates
      pkgs-edge = import nixpkgs-edge {
        system = pkgs.system;
        config = { allowUnfree = true;
                  allowUnfreePredicate = (_: true); };
      };

      # system is built on nixos unstable 
      lib = nixpkgs.lib;
    in {
      nixosConfigurations.${systemSettings.hostname} = lib.nixosSystem {
        modules = [
          ./configuration.nix # main nix configuration
          inputs.chaotic.nixosModules.default # chaotic nix bleeding edge packages

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          inputs.home-manager.nixosModules.default
        ]
        ++
        # Enable Lanzaboote if secureboot is configured
        lib.optionals (systemSettings.secureboot) [
          inputs.lanzaboote.nixosModules.lanzaboote 
        ];
        # pass the custom settings and flakes to system
        specialArgs = {
          inherit inputs;
          inherit pkgs-edge;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
    
  # Main sources and repositories
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; # Unstable NixOS system (default)
    nixpkgs-edge.url = "nixpkgs/master"; # Only used for bleeding edge packages
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # Bleeding edge packages from chaotic nix

    # FIXME: when https://github.com/NixOS/nixpkgs/pull/304469 is merged to nixos-unstable, remove this
    ananicy-fix.url = "github:JohnRTitor/nixpkgs/7466a6d7a4ff5e1af0d0f0304a89a0b717aa9eac"; # Ananicy update for nixpkgs

    lanzaboote.url = "github:nix-community/lanzaboote"; # lanzaboote, used for secureboot

    hyprland.url = "github:hyprwm/Hyprland"; # Latest Hyprland from official repo

    home-manager = {  url = "github:nix-community/home-manager/master";
                      inputs.nixpkgs.follows = "nixpkgs"; };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions"; # latest vs code extensions flake
    devenv.url = "github:cachix/devenv"; # Devenv flake
  };
}
