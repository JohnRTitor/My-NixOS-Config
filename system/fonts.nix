# This conf file is used to configure fonts
{pkgs, ...}: {
  # FONTS
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code # used in VS code
    noto-fonts-cjk
    jetbrains-mono
    font-awesome
    (nerdfonts.override {
      # Nerd fonts, must for icons
      fonts = [
        "JetBrainsMono" # used in VS code terminal
        "InconsolataLGC" # used in Alacritty, VS code
        "FiraCode" # used in VS code
        "Cousine" # Preferred by me as GTK font
      ];
    })
    roboto
    lohit-fonts.bengali # Bengali fonts
    # ultimate-oldschool-pc-font-pack
  ];

  fonts.fontDir.enable = true;
  fonts.fontconfig = {
    subpixel.rgba = "rgb"; # Subpixel rendering
    antialias = true;
    hinting.enable = true;
    useEmbeddedBitmaps = true; # for better rendering of Calibri like fonts
    cache32Bit = true;
  };

  # Console fonts
  console = {
    font = "ter-124b";
    keyMap = "us";
    packages = with pkgs; [
      terminus_font
    ];
  };
}
