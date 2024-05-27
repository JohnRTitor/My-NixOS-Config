# Configure graphics and hardware acceleration settings etc.
{
  config,
  pkgs,
  ...
}: {
  # Enable OpenGL and Vulkan support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # Extra drivers
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk # AMD Vulkan driver
      vaapiVdpau
      libvdpau-va-gl
      libva
    ];
    # For 32 bit applications
    extraPackages32 = with pkgs.driversi686Linux; [
      amdvlk
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.systemPackages = with pkgs; [
    ## GRAPHICS UTILS ##
    libva-utils # libva graphics library tools
    vdpauinfo # vdpau graphics library tools
    vulkan-tools # vulkan graphics library tools
  ];

  # Also load amdgpu at boot
  boot.kernelModules = ["amdgpu"];
  boot.extraModulePackages = with config.boot.kernelPackages; [amdgpu-pro];

  # AMDGPU graphics driver for Xorg
  services.xserver.videoDrivers = ["amdgpu"];

  # Disable radeon and enable amdgpu
  boot.kernelParams = [
    "radeon.si_support=0"
    "amdgpu.si_support=1"
  ];

  # Graphics environment variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };
}
