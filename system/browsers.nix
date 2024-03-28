# This config file is used to configure browsers
{ pkgs, ... }:
{
  # Enable Firefox Wayland
  programs.firefox = {
  	enable = true;
  	package = pkgs.firefox-wayland;
    policies = {
      DontCheckDefaultBrowser = true; # disable the annoying popup at startup
      HardwareAcceleration = true;
    };
  };

  environment.systemPackages = with pkgs; [
    (google-chrome.override {
      # enable video encoding and hardware acceleration, along with several
      # suitable for my configuration
      # change it if you have any issues
      # note the spaces, they are required
      # Vulkan is not stable, likely because of drivers
      commandLineArgs = ""
        + " --enable-accelerated-video-decode"
        + " --enable-accelerated-mjpeg-decode"
        + " --enable-gpu-compositing"
        + " --enable-gpu-rasterization" # dont enable in about:flags
        + " --enable-native-gpu-memory-buffers"
        + " --enable-raw-draw"
        + " --enable-zero-copy" # dont enable in about:flags
        + " --ignore-gpu-blocklist" # dont enable in about:flags
        # + " --use-vulkan"
        + " --enable-features="
          + "VaapiVideoEncoder,"
          + "CanvasOopRasterization,"
          # + "Vulkan"
        ;
    })
  ];
}