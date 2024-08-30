# Configure system services
{
  config,
  lib,
  pkgs,
  systemSettings,
  servicesSettings,
  ...
}: {
  imports =
    [
      ./ananicy-cpp.nix
      ./apparmor.nix
      ./console-tty.nix
      ./gnome-keyring.nix
      ./gnupg-ssh.nix
    ]
    ++ lib.optionals servicesSettings.containers [./containers.nix];

  ## Essential services ##
  # Enable xserver with xwayland
  services.xserver = {
    enable = true;
    # don't need xterm
    excludePackages = [pkgs.xterm];
  };

  # Enable scx extra schedulers, only available for linux-cachyos
  chaotic.scx.enable = (config.boot.kernelPackages.kernel.passthru.config.CONFIG_SCHED_CLASS_EXT or null) == "y"; # by default uses rustland
  chaotic.scx.scheduler = "scx_bpfland";

  # Accounts daemon is needed to remember passwords and other account information
  # by display manager and other services
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
        "${pkgs.kitty}/share/applications/kitty.desktop"
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

  # services.colord.enable = true; # For color management
}
