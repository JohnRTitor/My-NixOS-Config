# This conf file is used to configure fonts
{ pkgs, ... }:
{
  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code # used in VS code
    noto-fonts-cjk
    jetbrains-mono
    font-awesome
    (nerdfonts.override { # Nerd fonts, must for icons
      fonts = [
        "JetBrainsMono" # used in VS code terminal
        "InconsolataLGC" # used in Alacritty, VS code
        "FiraCode" # used in VS code
      ];
    })
    lohit-fonts.bengali # Bengali fonts
  ];
}