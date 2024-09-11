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
}
