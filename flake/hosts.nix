{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-edge;
  inherit (nixpkgs) lib; # use lib from nixpkgs

  inherit (import ../preferences.nix) systemSettings userSettings;

  # configure pkgs from unstable (default)
  pkgs = import nixpkgs {
    # Add zen4 support
    localSystem = let
      featureSupport = arch: nixpkgs.lib.mapAttrs (_: f: f arch) nixpkgs.lib.systems.architectures.predicates;
    in
      {system = systemSettings.systemarch;} // featureSupport "znver4";

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  # bleeding edge packages from nixpkgs unstable branch, for packages that need immediate updates
  pkgs-edge = import nixpkgs-edge {
    system = pkgs.system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
in {
  flake = {
    nixosConfigurations.${systemSettings.hostname} = lib.nixosSystem {
      specialArgs = {inherit self inputs pkgs-edge systemSettings userSettings;};

      modules =
        [
          ../default-host/configuration.nix # main nix configuration
          inputs.chaotic.nixosModules.default # chaotic nix bleeding edge packages
          inputs.nur.nixosModules.nur

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          inputs.home-manager.nixosModules.default
        ]
        ++ lib.optionals systemSettings.secureboot [inputs.lanzaboote.nixosModules.lanzaboote];
    };
  };
}
