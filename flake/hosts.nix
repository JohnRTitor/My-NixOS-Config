{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-edge;
  inherit (nixpkgs) lib; # use lib from nixpkgs

  inherit (import ../preferences.nix) systemSettings userSettings;

  # bleeding edge packages from nixpkgs unstable branch, for packages that need immediate updates
  pkgs-edge = import nixpkgs-edge {
    system = systemSettings.systemarch;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      android_sdk.accept_license = true;
    };
  };

  specialArgs = {inherit self inputs pkgs-edge systemSettings userSettings;};
in {
  flake = {
    nixosConfigurations.${systemSettings.hostname} = lib.nixosSystem {
      inherit specialArgs;
      modules =
        [
          ../default-host/configuration.nix # main nix configuration
          inputs.chaotic.nixosModules.default # chaotic nix bleeding edge packages
          inputs.nur.nixosModules.nur # NUR - NixOS user repository
          inputs.ucodenix.nixosModules.ucodenix # ucodeNix - CPU microcode updates
          inputs.nix-flatpak.nixosModules.nix-flatpak # nix-flatpak, allows flatpak declaratively

          # install home-manager as NixOS module
          # so that it automatically gets deployed when running `nixos-rebuild switch`
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # backupFileExtension = ".hm.bak";
              extraSpecialArgs =
                specialArgs
                // {
                  # extra arguments for home-manager
                };
            };

            home-manager.users.${userSettings.username} = {
              imports = [
                ../home-manager
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
              ];
            };
          }
        ]
        ++ lib.optionals systemSettings.secureboot [inputs.lanzaboote.nixosModules.lanzaboote];
    };
  };
}
