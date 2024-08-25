# Configure hyprland window manager
# this config file contains package, portal and services declaration
# made specifically for hyprland
{
  self,
  config,
  lib,
  pkgs,
  pkgs-edge,
  inputs,
  ...
}: let
  hyprlandFlake = true;
  pkgs-hyprland =
    if hyprlandFlake
    then inputs.hyprland.packages.${pkgs.system}
    else pkgs-edge;
in {
  imports = [
    ./session.nix
  ];

  # Enable Hyprland Window Manager
  programs.hyprland = {
    enable = true;
    package =
      (pkgs-hyprland.hyprland.override {
        #stdenv = pkgs.clangStdenv;
      })
      .overrideAttrs
      (prevAttrs: {
        patches =
          (prevAttrs.patches or [])
          ++ [
            #./enable-lto.patch
            ./add-env-vars-to-export.patch
          ];
      });
    portalPackage = pkgs-hyprland.xdg-desktop-portal-hyprland;
  };

  # hyprland portal is already included, gtk is also needed for compatibility
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];

  ## QT theming ##
  qt = {
    enable = true;
    style = "kvantum";
    platformTheme = "qt5ct";
  };

  ## Configure essential programs ##

  programs.waybar = {
    enable = true; # enable waybar launcher
    package = pkgs.waybar; # inputs.waybar.packages.${pkgs.system}.waybar;
  };

  programs.hyprlock = {
    enable = true; # enable Hyprlock screen locker
    package = pkgs.hyprlock; # inputs.hyprlock.packages.${pkgs.system}.hyprlock;
  };

  services.hypridle = {
    enable = true; # enable Hypridle idle manager, needed for Hyprlock
    package = pkgs.hypridle; # inputs.hypridle.packages.${pkgs.system}.hypridle;
  };

  programs = {
    evince.enable = true; # document viewer
    file-roller.enable = true; # archive manager
  };

  services.gnome = {
    sushi.enable = true; # quick previewer for nautilus
    glib-networking.enable = true; # network extensions libs
  };

  services.tumbler.enable = true; # thumbnailer service

  ## Configure essential packages ##

  environment.systemPackages =
    (with pkgs; [
      # Hyprland Stuff main
      cava # audio visualizer
      cliphist # clipboard history
      grim # screenshots
      jq # json parser
      networkmanagerapplet
      nwg-look # theme switcher
      openssl # required by Rainbow borders
      pamixer
      pavucontrol # audio control
      playerctl # media player control
      pantheon.pantheon-agent-polkit # polkit agent for root prompt
      # POLKIT service is manually started
      # as defined in Hyprland-Dots repo
      rofi-wayland # app launcher
      slurp # screenshots
      swappy # screenshots
      swaynotificationcenter # notification daemon
      swww # wallpaper daemon
      wallust # pywal alternative, graphical pallete generator
      wlsunset # for night mode
      wl-clipboard # clipboard manager
      wlogout # logout dialog
      yad

      gsettings-desktop-schemas
      wlr-randr # xrandr but for wayland
      ydotool

      ## Graphical apps ##

      kitty # default terminal on hyprland
      linux-wifi-hotspot # for wifi hotspot
      (mpv-unwrapped.override {
        # mpv with more features
        jackaudioSupport = true;
        vapoursynthSupport = true;
      }) # for video playback, needed for some scripts
      mpvScripts.mpris

      ## Utilities ##
      desktop-file-utils
      shared-mime-info
      xdg-utils
      xdg-user-dirs
      xorg.xhost # needed for some packages running x11 like gparted

      ## GNOME Suite ##
      nautilus # file manager
      gnome-text-editor # text editor
      shotcut # video editor
      gnome-system-monitor # system monitor
      loupe # image viewer

      ## Hypr ecosystem ##
      hyprcursor
      pyprland # hyprland plugin, dropdown term, etc
      ags # widgets pipup
    ])
    ++ [
      self.packages.${pkgs.system}.weather-python-script # weather script
      # inputs.hyprcursor.packages.${pkgs.system}.hyprcursor
      # inputs.pyprland.packages.${pkgs.system}.pyprland
      # inputs.ags.packages.${pkgs.system}.ags
      # inputs.wallust.packages.${pkgs.system}.wallust
    ];

  # Environment variables to start the session with
  environment.sessionVariables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";

    NIXOS_OZONE_WL = "1"; # for electron and chromium apps to run on wayland
    MOZ_ENABLE_WAYLAND = "1"; # firefox should always run on wayland

    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GTK_USE_PORTAL = "1"; # makes dialogs (file opening) consistent with rest of the ui
  };
}
