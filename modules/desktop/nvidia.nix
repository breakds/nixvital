{ config, lib, pkgs, ... }:

let cfg = config.vital.desktop.nvidia;

in lib.mkIf cfg.enable {
  services.xserver.videoDrivers = [ "nvidia" ];
  # Disable Wayland if nvidia is on.
  services.xserver.displayManager.gdm.wayland = false;

  hardware = {
    # Nvidia PRIME The card Nvidia 940MX is non-MXM card. Needs special treatment.
    # muxless/non-MXM Optimus cards have no display outputs and show as 3D
    # Controller in lspci output, seen in most modern consumer laptops
    nvidia.prime.sync.enable = cfg.prime.enable;
    nvidia.modesetting.enable = cfg.prime.enable;
    opengl.driSupport32Bit = true;

    # Bus ID of the NVIDIA GPU. You can find it using lspci
    nvidia.prime.nvidiaBusId = cfg.prime.nvidiaBusId;

    # Bus ID of the Intel GPU. You can find it using lspci
    nvidia.prime.intelBusId = cfg.prime.intelBusId;
  };

  environment.systemPackages = lib.mkIf cfg.withCuda (with pkgs; [
    cudatoolkit
  ]);
}
