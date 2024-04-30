{ pkgs, ... }:
{
  # Enable Ananicy CPP for better system performance
  services.ananicy = {
    enable = true;
    # from nixpkgs: ananicy-rules-cachyos
    rulesProvider = pkgs.ananicy-cpp-rules.overrideAttrs (oldAttrs: {
      patches = [
        (pkgs.fetchpatch {
          # FIXME: remove when https://github.com/CachyOS/ananicy-rules/pull/87 is merged and available in nixpkgs/chaotic
          name = "update-services-rules.patch";
          url = "https://patch-diff.githubusercontent.com/raw/CachyOS/ananicy-rules/pull/87.patch";
          hash = "sha256-Xu9Kd9YJKEamaHLqCi/b0bl7pdjwO/OzCCEr7cX3VuY=";
        })
      ];
    });
  };
}
