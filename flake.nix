{

  description = "Flake file of John Titor";

  inputs = {
    # Stable nixpkgs (23.11)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    # Unstable nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # lanzaboote, used for secureboot
    lanzaboote.url = "github:nix-community/lanzaboote";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, lanzaboote, home-manager, ... }:
    let

      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "Ainz-NIX"; # hostname
        timezone = "Asia/Kolkata"; # select timezone
        locale = "en_IN"; # select locale
      };

      # ----- USER SETTINGS ----- #
      userSettings = {
        username = "masum"; # username
        name = "Masum R."; # name/identifier
        gitname = "John Titor"; # git name
        email = "masumrezarock100@gmail.com"; # email (used for certain configurations)
      };

      # configure stable pkgs
      pkgs = import nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        # overlays = [ rust-overlay.overlays.default ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        # overlays = [ rust-overlay.overlays.default ];
      };

      # configure lib
      lib = nixpkgs.lib;
    in {
      nixosConfigurations.${systemSettings.hostname} = lib.nixosSystem {
        system = systemSettings.system;

        modules = [
          ./configuration.nix # main nix configuration
          lanzaboote.nixosModules.lanzaboote # lanzaboote for secureboot

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${userSettings.username} = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }

        ];
        specialArgs = {
          inherit pkgs-unstable;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };

}
