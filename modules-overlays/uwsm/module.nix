{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.uwsm;
  mk_uwsm_desktop_entry = opts: (pkgs.writeTextFile {
    name = "${opts.name}";
    text = ''
      [Desktop Entry]
      Name=${opts.compositor_pretty_name} (UWSM)
      Comment=${opts.compositor_comment}
      Exec=${lib.getExe cfg.package} start -S -F "${opts.compositor_bin_path}"
      Type=Application
    '';
    destination = "/share/wayland-sessions/${opts.name}_uwsm.desktop";
    derivationArgs = {
      passthru.providedSessions = ["${opts.name}_uwsm"];
    };
  });
in {
  options.programs.uwsm = {
    enable = lib.mkEnableOption ''      uwsm, which wraps standalone
            Wayland compositors into a set of Systemd units on the fly
    '';
    package = lib.mkPackageOption pkgs "uwsm" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    systemd.packages = [cfg.package];
    environment.pathsToLink = ["/share/uwsm"];

    # UWSM recommends dBus broker for better compatibility
    services.dbus.implementation = "broker";

    services.displayManager.sessionPackages =
      lib.optionals config.programs.hyprland.enable [
        (mk_uwsm_desktop_entry {
          name = "hyprland";
          compositor_pretty_name = "Hyprland";
          compositor_comment = "Hyprland compositor managed by UWSM";
          compositor_bin_path = "/run/current-system/sw/bin/Hyprland";
        })
      ]
      ++ lib.optionals config.programs.sway.enable [
        (mk_uwsm_desktop_entry {
          name = "sway";
          compositor_pretty_name = "Sway";
          compositor_comment = "Sway compositor managed by UWSM";
          compositor_bin_path = "/run/current-system/sw/bin/sway";
        })
      ];
  };

  meta.maintainers = with lib.maintainers; [johnrtitor];
}
