{ pkgs, ... }:
{
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
          hash = "sha256-QHMCWWNsgJW2AL+jd6SVAXAs/STUIYUdpCs67X23XF4=";
        })
      ];
    });
  };
}