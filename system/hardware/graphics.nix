# Configure graphics and hardware acceleration settings etc.
{
  config,
  pkgs,
  pkgs-edge,
  ...
}: let
  nur-amdgpu = config.nur.repos.materus;
in {
  hardware.firmware = with nur-amdgpu; [
    amdgpu-pro-libs.firmware.vcn
    amdgpu-pro-libs.firmware
  ];

  # Enable OpenGL and Vulkan support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # Extra drivers
    extraPackages =
      (with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        libva
        rocmPackages.clr.icd # OpenCL for AMD GPUs
      ])
      ++ (with pkgs-edge; [
        pocl # OpenCL for CPU
      ])
      ++ (with nur-amdgpu; [
        amdgpu-pro-libs.opengl
        amdgpu-pro-libs.vulkan
        amdgpu-pro-libs.amf
      ]);
    # For 32 bit applications
    extraPackages32 = with pkgs.driversi686Linux; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
  environment.systemPackages = with pkgs; [
    ## GRAPHICS UTILS ##
    clinfo # OpenCL hardware information
    libva-utils # libva graphics library tools
    vdpauinfo # vdpau graphics library tools
    vulkan-tools # vulkan graphics library tools
  ];

  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.legacySupport.enable = true;
  hardware.amdgpu.opencl.enable = false;

  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
    supportExperimental.enable = true;
    settings = {
      AllowVkPipelineCachingToDisk = 1;
      ShaderCacheMode = 1;
      IFH = 0;
      EnableVmAlwaysValid = 1;
      IdleAfterSubmitGpuMask = 0;
    };
  };

  # Use modesetting driver for Xorg, its better and updated
  # AMDGPU graphics driver for Xorg is deprecated
  services.xserver.videoDrivers = ["modesetting"];

  # Graphics environment variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };
}
