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
    "${inputs.nixpkgs-jupyter-service-fix}/nixos/modules/services/development/jupyter/default.nix"
  ];

  disabledModules = [
    "${inputs.nixpkgs}/nixos/modules/services/development/jupyter/default.nix"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      jack1 = pkgs-master.jack1;
      pocl = pkgs-master.pocl;
      rocmPackages = pkgs-master.rocmPackages;
    })
  ];
}
