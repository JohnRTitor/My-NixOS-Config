{
  stdenv,
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  meson,
  ninja,
  scdoc,
  pkg-config,
  nix-update-script,
  bash,
  dmenu,
  libnotify,
  newt,
  python3Packages,
  util-linux,
  fumonSupport ? true,
  uuctlSupport ? true,
  uwsmAppSupport ? true,
  hyprlandSupport ? false,
  swaySupport ? false,
  hyprland,
  sway,
}:
let
  python = python3Packages.python.withPackages (ps: [
    ps.pydbus
    ps.dbus-python
    ps.pyxdg
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "uwsm";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "uwsm";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-M2j7l5XTSS2IzaJofAHct1tuAO2A9Ps9mCgAWKEvzoE=";
  };

  patches = [ ./uwsm-path.patch ];

  nativeBuildInputs = [
    makeBinaryWrapper
    meson
    ninja
    pkg-config
    scdoc
  ];

  propagatedBuildInputs = [
    util-linux # waitpid
    newt # whiptail
    dmenu # for uuctl
    libnotify # notify
    bash # sh
    python
  ];

  mesonFlags = [
    "--prefix=${placeholder "out"}"
    (lib.mapAttrsToList lib.mesonEnable {
      "uwsm-app" = uwsmAppSupport;
      "fumon" = fumonSupport;
      "uuctl" = uuctlSupport;
      "man-pages" = true;
    })
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  postInstall = ''
    wrapProgram $out/bin/uwsm \
      --prefix PATH : ${
        lib.makeBinPath (
          finalAttrs.propagatedBuildInputs
          ++ (lib.optional hyprlandSupport hyprland)
          ++ (lib.optional swaySupport sway)
        )
      }
    ${lib.optionalString uuctlSupport ''
      wrapProgram $out/bin/uuctl \
        --prefix PATH : ${lib.makeBinPath finalAttrs.propagatedBuildInputs} 
    ''}
  '';

  meta = {
    description = "Universal wayland session manager";
    homepage = "https://github.com/Vladimir-csp/uwsm";
    mainProgram = "uwsm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnrtitor ];
    platforms = lib.platforms.linux;
  };
})
