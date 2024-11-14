{
  lib,
  pkgs,
  pkgs-master,
  inputs,
  ...
}: {
  imports = [
    #./amdgpu.nix # import modules here to test
    "${inputs.nixpkgs-scx-test}/nixos/modules/services/scheduling/scx.nix"
    "${inputs.nixpkgs-master}/nixos/modules/security/soteria.nix"
  ];
}
