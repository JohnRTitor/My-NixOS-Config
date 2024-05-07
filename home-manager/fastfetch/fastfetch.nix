# this config file installs fastfetch, places configs in the right place and sets up the configs
{pkgs, ...}: {
  home.packages = with pkgs; [fastfetch];

  home.file.".config/fastfetch/config.jsonc".source = ./config.jsonc;
  home.file.".config/fastfetch/config-compact.jsonc".source = ./config-compact.jsonc;
}
