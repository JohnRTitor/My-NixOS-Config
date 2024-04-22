{ pkgs, ... }:
{
  # Enable Ananicy CPP for better system performance
  services.ananicy = {
    enable = true;
    # from nixpkgs: ananicy-rules-cachyos
    rulesProvider = pkgs.ananicy-cpp-rules;
  };
}