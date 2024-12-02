{
  lib,
  pkgs,
  pkgs-edge,
  pkgs-master,
  inputs,
  ...
}: {
  imports = [
    #./amdgpu.nix # import modules here to test
    "${inputs.nixpkgs-ananicy-service-fix}/nixos/modules/services/misc/ananicy.nix"
  ];

  disabledModules = [
    "${inputs.nixpkgs}/nixos/modules/services/misc/ananicy.nix"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      cava = inputs.nixpkgs-cava-fix.legacyPackages.${pkgs.system}.cava;
    })
  ];
}
