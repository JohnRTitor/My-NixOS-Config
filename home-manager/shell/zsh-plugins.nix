{
  lib,
  pkgs,
  ...
}: {
  # Zsh plugins
  programs.zsh.plugins = [
    {
      name = "zsh-autocomplete";
      src = pkgs.fetchFromGitHub {
        owner = "marlonrichert";
        repo = "zsh-autocomplete";
        rev = "196810035992abea65e54852c4278af2069ee482"; # latest commit
        hash = "sha256-bzOTeYWrzuYNbeat30zijKJ9kflRhdE/0wD2HwZWXbU=";
      };
    }
    {
      name = "fast-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zdharma-continuum";
        repo = "fast-syntax-highlighting";
        rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9"; # latest commit
        hash = "sha256-RVX9ZSzjBW3LpFs2W86lKI6vtcvDWP6EPxzeTcRZua4=";
      };
    }
  ];
  programs.zsh.enableCompletion = lib.mkForce false; # disable for zsh autocomplete plugin
}
