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
      jack1 = pkgs-master.jack1;
      pocl = pkgs-master.pocl;
      rocmPackages = pkgs-master.rocmPackages;
    })
  ];
}
