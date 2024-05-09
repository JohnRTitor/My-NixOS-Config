{pkgs, ...}: {
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      # Extra libraries and packages for Appimage run
      extraPkgs = pkgs:
        with pkgs; [
          ffmpeg
          imagemagick
        ];
    };
  };
  # services.flatpak.enable = true; # enable flatpak support
  # Enable aarch64-linux cross-compilation and running those binaries
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
