{
  lib,
  stdenvNoCC,
  writeText,
  uwsm,
  wmName ? "Example",
  wmCmd ? "example",
}: let
  wm-desktop-entry = writeText "${wmName}_uwsm.desktop" ''
    [Desktop Entry]
    Name=${wmName} (with UWSM)
    Comment=${wmName} compositor managed by UWSM
    Exec=${lib.getExe uwsm} start -S -- ${wmCmd}
    Type=Application
  '';
in
  stdenvNoCC.mkDerivation {
    pname = "${wmName}_uwsm";
    version = "1.0.0";
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/wayland-sessions
      cp ${wm-desktop-entry} $out/share/wayland-sessions/${wmName}_uwsm.desktop
      runHook postInstall
    '';
    passthru.providedSessions = ["${wmName}_uwsm"];
  }
