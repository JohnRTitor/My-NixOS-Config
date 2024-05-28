# Configure system services
{
  lib,
  pkgs,
  systemSettings,
  ...
}: {
  imports =
    [
      ./ananicy-cpp.nix
      ./console-tty.nix
      ./gnome-keyring.nix
    ]
    ++ lib.optionals systemSettings.containers [./containers.nix];

  ## Essential services ##
  # Enable xserver with xwayland
  services.xserver = {
    enable = true;
    # don't need xterm
    excludePackages = [pkgs.xterm];
  };
  services.accounts-daemon.enable = true;
  services.dbus = {
    enable = true;
    implementation = "broker"; # use new dbus-broker
  };
  services.udev.enable = true;
  programs.dconf.enable = true;

  # include zsh support, bash is enabled by default
  # this only includes zsh package
  programs.zsh.enable = true;
  # zsh is also enabled for user, conditionally at ./users.nix
  # set the user shell in ../flake.nix

  ## Configure XDG portal ##
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true; # use xdg-open with xdg-desktop-portal
  };
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
      /*
      GNOME = [
        "com.raggesilver.BlackBox.desktop"
        "org.gnome.Terminal.desktop"
      ];
      */
    };
  };

  # XDG portal paths to link if useUserPackages=true is enabled in home-manager (flake.nix)
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  services.timesyncd.enable = true; # For time synchronization
  services.fwupd.enable = true; # For firmware updates
  # Mitigate issue where like /usr/bin/bash, hardcoded links in scripts not found
  services.envfs.enable = true;

  security.polkit.enable = true; # Enable polkit for elevated prompts

  security.apparmor.enable = true;
  security.apparmor.enableCache = true;
  services.dbus.apparmor = "enabled";

  services.colord.enable = true; # For color management
}
