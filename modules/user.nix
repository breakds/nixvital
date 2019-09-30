{ config, lib, pkgs, ... }:

{
  users = {
    extraUsers = {
      breakds = {
        isNormalUser = true;
	initialPassword = "breakds";
	home = "/home/breakds";
        uid = 1000;
	description = "Break Yang";
        extraGroups = [
	        "breakds"
	        "wheel"  # Enable `sudo`
	        "networkmanager"
	        "dialout"  # Access /dev/ttyUSB* devices
	        "uucp"  # Access /ev/ttyS... RS-232 serial ports and devices.
	        "audio"
	        "plugdev"  # Allow members to mount/umount removable devices via pmount.
	        "lxd"
	        "docker"
          "nginx"
	      ];
        useDefaultShell = true;
      };
    };
  };
}
