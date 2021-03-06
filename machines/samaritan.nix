{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../nix-home/breakds
    ../modules/users
    ../modules/desktop
    ../modules/IoT/apple-devices.nix
    ../modules/steam.nix
    ../modules/vm.nix
    ../modules/dev/python-environment.nix
    ../modules/dev/java.nix
    # ../modules/binary-caches/gilgamesh.nix
  ];

  # Temporarily build customized ethminer for 3060 Ti and Cuda 11,
  # which is also of the newest version.
  nixpkgs.overlays = [
    (self: super: {
      ethminer = self.callPackage ../pkgs/temp/ethminer {};
    })
  ];

  vital.machineType = "desktop";

  # Machine-specific networking configuration.
  networking.hostName = "samaritan";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "9c4a63a8";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
    xserver.dpi = 100;
    nvidia = {
      enable = true;
    };
  };

  # For ROS
  networking.firewall.allowedTCPPorts = [ 11311 ];

  # +------------+
  # | Gaming     |
  # +------------+

  # Support Logitech G29 Steering Wheel
  services.udev.packages = with pkgs; [
    usb-modeswitch-data
  ];

  # +-------------+
  # | Development |
  # +-------------+

  vital.dev.python = {
    batteries = {
      machineLearning = true;
    };
  };

  environment.systemPackages = with pkgs; [
    darktable axel gimp go-ethereum woeusb filezilla
  ];

  # +-------------+
  # | Services    |
  # +-------------+

  # Eth Mining
  services.ethminer = {
    enable = true;
    recheckInterval = 1000;
    toolkit = "cuda";
    wallet = "0xcdea2bD3AC8089e9aa02cC6CF5677574f76f0df2.samaritan3060Ti";
    pool = "us2.ethermine.org";
    stratumPort = 4444;
    maxPower = 240;
    registerMail = "";
    rig = "";
  };

  # Trezor cryptocurrency hardware wallet
  services.trezord.enable = true;
}
