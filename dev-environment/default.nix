{ config, lib, pkgs, pkgs-edge, userSettings, ... }:
let
  # To be able to use cachix cache from devenv
  # run `cachix use devenv`
  # has to be set
  useDevenv = true;
in
{
  # Configure the build environment

  # Containers and adb should be available by default
  imports = [
    ./containers.nix
    ./adb-toolchain.nix
  ]
  # if dev env is enabled don't install c and php toolchain
  ++ lib.optionals (!useDevenv)
  [
    ./deprecated/c-toolchain.nix
    ./deprecated/php.nix
  ];

  environment.systemPackages = (with pkgs-edge; [
    nixd # nix language server
  ]) ++ lib.optionals (useDevenv) (with pkgs-edge; [
    devenv
  ]);

  # Direnv to automatically enable local environment in a directory
  programs.direnv = {
    enable = true; # also enable direnv
    silent = true; # silent direnv outputs
  };
}