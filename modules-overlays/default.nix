{
  libs,
  pkgs,
  pkgs-edge,
  inputs,
  ...
}: {
  imports = [
    #./amdgpu.nix # import modules here to test
  ];

  nixpkgs.overlays = [
    (final: prev: {
      # bcachefs-tools = inputs.bcachefs-tools.packages.${pkgs.system}.bcachefs-tools;
    })
  ];
}
