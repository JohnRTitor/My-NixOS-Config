# Configure system services
{ pkgs, ... }:

{
  ## Essential services ##
  # Enable xserver with xwayland
  services.xserver = {
    enable = true;
    # don't need xterm
    excludePackages = [ pkgs.xterm ];
  };
  services.accounts-daemon.enable = true;
  services.dbus.enable = true;
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
  # XDG portal paths to link if useUserPackages=true is enabled in home-manager (flake.nix)
  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  # Enable Ananicy CPP for better system performance
  services.ananicy = {
    enable = true;
    # from nixpkgs: ananicy-rules-cachyos
    rulesProvider = pkgs.ananicy-cpp-rules.overrideAttrs (oldAttrs: rec {
      patches = [
        (pkgs.fetchpatch {
          # FIXME: remove when https://github.com/CachyOS/ananicy-rules/pull/80 is merged and available in nixpkgs
          name = "add-compiler-rules.patch";
          url = "https://patch-diff.githubusercontent.com/raw/CachyOS/ananicy-rules/pull/80.diff";
          hash = "sha256-GF2bjOaCkNaAP160C7Cs3DYs2FId5vcKeErG0ToHRbA=";
        })
        (pkgs.fetchpatch {
          # FIXME: remove when https://github.com/CachyOS/ananicy-rules/pull/84 is merged and available in nixpkgs
          name = "add-xdg-gvfs-misc.patch";
          url = "https://patch-diff.githubusercontent.com/raw/CachyOS/ananicy-rules/pull/84.patch";
          hash = "sha256-S2m+/xgjuAhFg7Ta4X5z150xgYEl917lw8wtoWU3C3M=";
        })
      ];
    });
  };

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
  
  # enable time synchronization, flatpak and fwupd
  services.timesyncd.enable = true;
  # services.flatpak.enable = true;
  services.fwupd.enable = true;
  # Mitigate issue where like /usr/bin/bash, hardcoded links in scripts not found
  services.envfs.enable = true;
  programs.openvpn3.enable = true;

  security.polkit.enable = true; # Enable polkit for elevated prompts
}
