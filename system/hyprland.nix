# Configure hyprland window manager
# this config file contains package, portal and services declaration
# made specifically for hyprland
{
  pkgs,
  pkgs-edge,
  inputs,
  ...
}: let
  python-packages = pkgs.python3.withPackages (
    ps:
      with ps; [
        requests
        sh # subprocess module
        pyquery # needed for hyprland-dots Weather script
      ]
  );
in {
  # use the hyprland package from the hyprland flake
  imports = [inputs.hyprland.nixosModules.default];
  # Enable Hyprland Window Manager
  programs.hyprland = {
    enable = true;
    systemd.setPath.enable = true;
  };

  # hyprland portal is already included, gtk is also needed for compatibility
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];

  # Enable GDM with wayland
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
    banner = ''
                      Welcome Traveler, Behold!
      You are about to enter the realm of Hyprland
    '';
  };

  ## QT theming ##
  qt = {
    enable = true;
    style = "kvantum";
    platformTheme = "qt5ct";
  };

  ## Configure essential programs ##

  programs.waybar = {
    enable = true; # enable waybar launcher
    package = inputs.waybar.packages.${pkgs.system}.waybar;
  };

  programs = {
    evince.enable = true; # document viewer
    file-roller.enable = true; # archive manager
    # Xfce file manager
    # thunar = {
    #   enable = true;
    #   plugins = with pkgs.xfce; [
    #     exo
    #     mousepad # text editor
    #     thunar-archive-plugin # archive manager
    #     thunar-volman
    #  ];
    # };
    # nm-applet.enable = true; # network manager applet for xorg
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
      polkit_gnome # needed for apps requesting root access
      pywal # for automatic color schemes from wallpaper
      rofi-wayland
      slurp # screenshots
      swappy # screenshots
      swaynotificationcenter # notification daemon
      swww
      wlsunset # for night mode
      wl-clipboard
      wlogout
      yad

      gsettings-desktop-schemas
      wlr-randr # xrandr but for wayland
      ydotool

      ## Graphical apps ##
      gnome.gnome-system-monitor # system monitor
      loupe # image viewer
      kitty # default terminal on hyprland
      linux-wifi-hotspot # for wifi hotspot
      (mpv-unwrapped.override {
        # mpv with more features
        jackaudioSupport = true;
        vapoursynthSupport = true;
      }) # for video playback, needed for some scripts
      mpvScripts.mpris
      gnome.nautilus # file manager
      gnome-text-editor # text editor
      shotcut # video editor

      ## QT theming and apps support ##
      qt5.qtwayland
      qt6.qmake
      qt6.qtwayland

      ## Utilities ##
      desktop-file-utils
      shared-mime-info
      xdg-utils
      xdg-user-dirs
      xorg.xhost # needed for some packages running x11 like gparted

      ## Hypr ecosystem ##
      # hyprcursor
      # hyprpicker # does not work
      # hyprpaper # alternative to swww, but shit
      # hyprlock
      # hypridle
      pyprland
    ])
    ++ [
      python-packages # needed for Weather.py from dotfiles
      inputs.hyprcursor.packages.${pkgs.system}.hyprcursor
      inputs.hyprlock.packages.${pkgs.system}.hyprlock
      inputs.hypridle.packages.${pkgs.system}.hypridle
      # inputs.pyprland.packages.${pkgs.system}.pyprland
      inputs.ags.packages.${pkgs.system}.ags
      inputs.wallust.packages.${pkgs.system}.wallust
    ];

  # Environment variables to start the session with
  environment.sessionVariables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    # WLR_NO_HARDWARE_CURSORS = "1"; # cursor not visible, needed for nvidia

    NIXOS_OZONE_WL = "1"; # for electron and chromium apps to run on wayland
    MOZ_ENABLE_WAYLAND = "1"; # firefox should always run on wayland

    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GTK_USE_PORTAL = "1"; # makes dialogs (file opening) consistent with rest of the ui
    # WLR_RENDERER = "vulkan"; # vulkan not supported in hyprland
  };

  systemd = {
    # Polkit starting systemd service - needed for apps requesting root access
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  security.pam.services.hyprlock = {};
}
