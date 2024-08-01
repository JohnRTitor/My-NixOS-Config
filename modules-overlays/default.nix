{
  libs,
  pkgs,
  pkgs-edge,
  inputs,
  ...
}: {
  imports = [
    #./amdgpu.nix # import modules here to test
    ./uwsm/module.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      # bcachefs-tools = inputs.bcachefs-tools.packages.${pkgs.system}.bcachefs-tools;
    })
  ];

  programs.uwsm.enable = true;
  programs.uwsm.package = pkgs-edge.uwsm;

  boot.kernelParams = [ "systemd.unified_cgroup_hierachy=0" "SYSTEMD_CGROUP_ENABLE_LEGACY_FORCE=1" ];
}
