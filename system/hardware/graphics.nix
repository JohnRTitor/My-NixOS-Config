# Configure graphics and hardware acceleration settings etc.
{ config, pkgs, ... }:

{
  # Enable OpenGL
  hardware.opengl = {
    enable = true; # Mesa
    driSupport = true; # Vulkan
    driSupport32Bit = true;
    # Extra drivers
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk # AMD Vulkan driver, replaces mesa-vulkan-radeon
      vaapiVdpau
      libvdpau-va-gl
      libva
      libdrm
    ];
    # For 32 bit applications 
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
      driversi686Linux.vaapiVdpau
      driversi686Linux.libvdpau-va-gl
    ];
  };
  environment.systemPackages = with pkgs; [
    ## GRAPHICS UTILS ##
    libva-utils # libva graphics library tools
    vdpauinfo # vdpau graphics library tools
    vulkan-tools # vulkan graphics library tools
  ];

  # AMDGPU graphics driver - disabled in favor of modesetting driver
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  # Graphics environment variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    __GLX_VENDOR_LIBRARY_NAME = "amdgpu";
  };
}