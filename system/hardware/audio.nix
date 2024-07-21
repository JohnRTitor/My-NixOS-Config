# This conf file is used to configure audio and sound related settings
{...}: {
  # Enable sound with pipewire, don't enable pulseaudio.
  services.pipewire = {
    enable = true;
    alsa.enable = true; # alsa support
    alsa.support32Bit = true;
    pulse.enable = true; # pulseaudio compat
    jack.enable = true; # enable jack audio
  };
  # Enable rtkit for real-time scheduling, required for pipewire
  security.rtkit.enable = true;

  # Enable low latency
  services.pipewire.extraConfig.pipewire = {
    "92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 512;
        "default.clock.max-quantum" = 512;
      };
    };
  };
}
