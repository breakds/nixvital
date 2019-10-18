{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../modules/xserver.nix
    ../modules/desktop.nix
    ../modules/weride.nix
  ];

  # Machine-specific networking configuration.
  networking.hostName = "hunter";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "9e710e9b";

  # Enable nvidia driver
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    dpi = 150;
    displayManager.gdm.wayland = false;
  };

  # TODO(breakds): Enable optimus prime mode when it works on thinkpad t470p.

  # Nvidia PRIME The card Nvidia 940MX is non-MXM card. Needs special treatment.
  # muxless/non-MXM Optimus cards have no display outputs and show as 3D
  # Controller in lspci output, seen in most modern consumer laptops
  hardware.nvidia.optimus_prime.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.opengl.driSupport32Bit = true;
  
  # Bus ID of the NVIDIA GPU. You can find it using lspci
  hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:2:0:0";
  
  # Bus ID of the Intel GPU. You can find it using lspci
  hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";

  # Enable Nginx
  services.nginx.enable = true;

  # Enable nvidia-docker
  virtualisation.docker.enableNvidia = true;

  # Mount Nas
  # //10.1.50.20/Public /media/nas cifs credentials=/home/breakds/.smbcredentials,iocharset=utf8,uid=1000 0 0
  # //10.1.50.20/80t /media/us_nas_80t cifs credentials=/home/breakds/.smbcredentials,iocharset=utf8,uid=1000 0 0
  # //10.18.50.20/80t /media/gz_nas_80t cifs credentials=/home/breakds/.gzsmbcredentials,iocharset=utf8,uid=1000 0 0
  # //10.18.50.20/Public /media/gz_nas_50t cifs credentials=/home/breakds/.gzsmbcredentials,iocharset=utf8,uid=1000 0 0
  fileSystems."/media/nas" = {
    device = "//10.1.50.20/Public";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split7
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/home/breakds/.ussmbcredentials"];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
