{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.uwsm;
in
{
  options.programs.uwsm = {
    enable = lib.mkEnableOption ''uwsm, which wraps standalone
      Wayland compositors into a set of Systemd units on the fly
    '';
    package = lib.mkPackageOption pkgs "uwsm" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    services.dbus.implementation = "broker";

    services.displayManager.sessionPackages = lib.optionals config.programs.hyprland.enable [
      (pkgs.callPackage ./uwsm-wm-wrapper.nix {
        uwsm = cfg.package;
        wmName = "Hyprland";
        wmCmd = "/run/current-system/sw/bin/Hyprland";
      })
    ] ++ lib.optionals config.programs.sway.enable [
      (pkgs.callPackage ./uwsm-wm-wrapper.nix {
        uwsm = cfg.package;
        wmName = "Sway";
        wmCmd = "/run/current-system/sw/bin/sway";
      })
    ];
  };

  meta.maintainers = with lib.maintainers; [ johnrtitor ];
}
