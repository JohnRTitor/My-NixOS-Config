# Configure graphics and hardware acceleration settings etc.
{
  config,
  pkgs,
  ...
}: let
  nur-amdgpu = config.nur.repos.materus;
in {
  hardware.firmware = with nur-amdgpu; [
    amdgpu-pro-libs.firmware.vcn
    amdgpu-pro-libs.firmware
  ];

  # Enable OpenGL and Vulkan support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # Extra drivers
    extraPackages =
      (with pkgs; [
        rocmPackages.clr.icd
        amdvlk # AMD Vulkan driver
        vaapiVdpau
        libvdpau-va-gl
        libva
      ])
      ++ (with nur-amdgpu; [
        amdgpu-pro-libs.opengl
        amdgpu-pro-libs.vulkan
        amdgpu-pro-libs.amf
      ]);
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

  # Also load amdgpu at stage 1 of boot, to get better resolution
  boot.initrd.kernelModules = ["amdgpu"];

  # AMDGPU graphics driver for Xorg
  services.xserver.videoDrivers = ["amdgpu"];

  # Enable AMDGPU and disable Radeonsi
  boot.kernelParams = [
    "amdgpu.si_support=1"
    "amdgpu.cik_support=1"
    "radeon.si_support=0"
    "radeon.cik_support=0"
  ];

  # Graphics environment variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };
}
