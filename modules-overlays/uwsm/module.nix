{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.uwsm;
  hyprlandCfg = config.programs.hyprland;
  swayCfg = config.programs.sway;
in
{
  options.programs.uwsm = {
    enable = lib.mkEnableOption ''uwsm, which wraps standalone
      Wayland compositors into a set of Systemd units on the fly
    '';
    package = lib.mkPackageOption pkgs "uwsm" {};
    hyprlandSupport = lib.mkEnableOption null // {
      default = cfg.enable && hyprlandCfg.enable;
    };
    swaySupport = lib.mkEnableOption null // {
      default = cfg.enable && swayCfg.enable;
    };
    
    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = cfg.package.override {
        hyprland = hyprlandCfg.package;
        sway = swayCfg.package;
        inherit (cfg) hyprlandSupport swaySupport;
      };
      defaultText = lib.literalExpression
        "`programs.uwsm.package` with applied configuration";
      description = ''
        The uwsm package after applying configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];
    systemd.packages = [ cfg.finalPackage ];
    services.dbus.implementation = "broker";

    services.displayManager.sessionPackages = lib.optionals cfg.hyprlandSupport [
      (pkgs.callPackage ./uwsm-wm-wrapper.nix {
        uwsm = cfg.finalPackage;
        wmName = "Hyprland";
        wmCmd = "hyprland";
      })
    ] ++ lib.optionals cfg.swaySupport [
      (pkgs.callPackage ./uwsm-wm-wrapper.nix {
        uwsm = cfg.finalPackage;
        wmName = "Sway";
        wmCmd = "sway";
      })
    ];
  };

  meta.maintainers = with lib.maintainers; [ johnrtitor ];
}
