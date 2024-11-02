{
  lib,
  pkgs,
  stdenvNoCC,
  fetchFromGitHub,
  php,
  nix-update-script,
  theme ? null,
  plugins ? [],
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adminer-pematon";

  version = "4.11";
  src = fetchFromGitHub {
    owner = "pematon";
    repo = "adminer";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-tijqPTPEc2Sp4OORlGALKHFOpf/QJ36bbNja3d3mpOU=";
  };

  nativeBuildInputs = [
    php
  ];

  buildPhase = ''
    runHook preBuild

    php compile.php

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp temp/export/adminer-${finalAttrs.version}.php $out/adminer.php
    cp ${./index.php} $out/index.php

    ${lib.optionalString (theme != null) ''
      cp designs/${theme}/adminer.css $out/adminer.css
    ''}

    # Copy base plugin
    mkdir -p $out/plugins
    cp plugins/plugin.php $out/plugins/plugin.php

    ${lib.optionalString (plugins != []) ''
      cp plugins/*.php $out/plugins/
      cp ${pkgs.writeText "$out/plugins.json" ''
        ${toString (builtins.toJSON plugins)}
      ''} $out/plugins.json
    ''}

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {};
  };

  meta = {
    description = "Database management in a single PHP file";
    homepage = "https://github.com/pematon/adminer";
    license = with lib.licenses; [asl20 gpl2Only];
    maintainers = with lib.maintainers; [
      johnrtitor
    ];
    platforms = lib.platforms.all;
  };
})
