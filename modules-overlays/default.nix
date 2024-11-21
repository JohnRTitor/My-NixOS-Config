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
  ];

  nixpkgs.overlays = [
    (final: prev: {
      cava = inputs.nixpkgs-cava-fix.legacyPackages.${pkgs.system}.cava;
    })
  ];
}
